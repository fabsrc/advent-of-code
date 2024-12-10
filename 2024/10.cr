# https://adventofcode.com/2024/day/10

alias Position = Tuple(Int32, Int32)

DIRS = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]

# Part 1
def get_trailhead_score_sum(input : String) : Int32
  map = {} of Tuple(Int32, Int32) => Int32

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |height, x|
      map[{x, y}] = height.to_i
    end
  end

  trails = map.select { |_, height| height == 0 }.map { |pos| [pos] }
  trailends = Hash(Position, Set(Position)).new { |hash, key|
    hash[key] = Set(Position).new
  }

  until trails.empty?
    current_trail = trails.pop
    pos, height = current_trail.last
    x, y = pos

    DIRS.each do |(dx, dy)|
      next_pos = {x + dx, y + dy}
      next_height = map[next_pos]?

      next unless next_height && next_height - height == 1

      if next_height == 9
        trailends[current_trail.first[0]].add(next_pos)
      else
        trails << current_trail + [{next_pos, next_height}]
      end
    end
  end

  trailends.values.sum(&.size)
end

# Part 2
def get_trailhead_rating_sum(input : String) : Int32
  map = {} of Position => Int32
  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |height, x|
      map[{x, y}] = height.to_i
    end
  end

  trails = map.select { |_, height| height == 0 }.map { |pos| [pos] }
  ratings = Hash(Position, Int32).new(0)

  until trails.empty?
    current_trail = trails.pop
    pos, height = current_trail.last
    x, y = pos

    DIRS.each do |(dx, dy)|
      next_pos = {x + dx, y + dy}
      next_height = map[next_pos]?

      next unless next_height && next_height - height == 1

      if next_height == 9
        ratings[current_trail.first[0]] += 1
      else
        trails << current_trail + [{next_pos, next_height}]
      end
    end
  end

  ratings.values.sum
end

test_input = <<-INPUT
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
INPUT

raise "Part 1 failed" unless get_trailhead_score_sum(test_input) == 36
raise "Part 2 failed" unless get_trailhead_rating_sum(test_input) == 81

if ARGV.size > 0
  input = ARGV[0]
  puts get_trailhead_score_sum(input)
  puts get_trailhead_rating_sum(input)
end
