# https://adventofcode.com/2023/day/23

class Graph
  alias Coord = Tuple(Int32, Int32)

  DIRECTIONS = {'^' => {0, -1}, '>' => {1, 0}, 'v' => {0, 1}, '<' => {-1, 0}}

  def initialize(@map_input : String, @with_slopes = true)
    @map = Hash(Coord, Char).new
    @start = {1, 0}
    @destination = {@map_input.lines.first.size - 2, @map_input.lines.size - 1}
    map_input.lines.each_with_index do |line, y|
      line.each_char_with_index do |char, x|
        @map[{x, y}] = char
      end
    end

    queue = Deque.new([@start])
    visited = Set(Coord).new
    @graph = Hash(Coord, Array(Tuple(Coord, Int32))).new { |hash, key|
      hash[key] = [] of Tuple(Coord, Int32)
    }

    until queue.empty?
      coord = queue.pop
      next if visited.includes?(coord)

      get_neighbors(coord).each do |neighbor|
        length = 1
        prev = coord
        position = neighbor
        blocked = false

        loop do
          neighbors = get_neighbors(position)
          if neighbors == [prev] && DIRECTIONS.keys.includes?(@map[position])
            blocked = true
            break
          end

          break if neighbors.size != 2

          neighbors.each do |neighbor|
            unless neighbor == prev
              length += 1
              prev = position
              position = neighbor
              break
            end
          end
        end

        next if blocked

        @graph[coord] << {position, length}
        queue << position
      end

      visited << coord
    end
  end

  def get_longest_path_length : Int32
    stack = [{@start, 0, [@start]}]
    lengths = [] of Int32

    until stack.empty?
      coord, length, visited = stack.pop

      if coord == @destination
        lengths << length
        next
      end

      @graph[coord].each do |(next_node, next_length)|
        unless visited.includes?(next_node)
          stack << {next_node, length + next_length, visited + [next_node]}
        end
      end
    end

    lengths.max
  end

  private def get_neighbors(coord : Coord)
    char = @map[coord]
    x, y = coord

    directions = if char != '.' && @with_slopes
                   [DIRECTIONS[char]]
                 else
                   DIRECTIONS.values
                 end

    directions.compact_map do |(dx, dy)|
      next_step = {x + dx, y + dy}
      next_char = @map[next_step]?
      next nil if next_char == '#' || next_char.nil?
      next_step
    end
  end
end

# Part 1
def get_length_of_longest_hike(map_input : String) : Int32
  Graph.new(map_input).get_longest_path_length
end

# Part 2
def get_length_of_longest_hike_without_slopes(map_input : String) : Int32
  Graph.new(map_input, false).get_longest_path_length
end

test_input = <<-INPUT
#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
INPUT

raise "Part 1 failed" unless get_length_of_longest_hike(test_input) == 94
raise "Part 2 failed" unless get_length_of_longest_hike_without_slopes(test_input) == 154

if ARGV.size > 0
  input = ARGV[0]
  puts get_length_of_longest_hike(input)
  puts get_length_of_longest_hike_without_slopes(input)
end
