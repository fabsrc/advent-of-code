# https://adventofcode.com/2024/day/6

# Part 1
def count_distinct_visited_positions(input : String) : Int32
  map = {} of Tuple(Int32, Int32) => Char
  cur_pos = {0, 0}
  vectors = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
  dir = 0

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |c, x|
      if c == '^'
        cur_pos = {x, y}
        map[{x, y}] = '.'
      else
        map[{x, y}] = c
      end
    end
  end

  visited = Set(Tuple(Int32, Int32)).new([cur_pos])

  loop do
    next_pos = {cur_pos[0] + vectors[dir][0], cur_pos[1] + vectors[dir][1]}
    pos_value = map[next_pos]?

    if pos_value == '#'
      dir = (dir + 1) % 4
    elsif pos_value == '.'
      cur_pos = next_pos
      visited << cur_pos
    else
      break
    end
  end

  visited.size
end

# Part 2
def count_positions_for_obstructions(input : String) : Int32
  map = {} of Tuple(Int32, Int32) => Char
  start_pos = {0, 0}
  vectors = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
  start_dir = 0
  count = 0

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |c, x|
      if c == '^'
        start_pos = {x, y}
        map[{x, y}] = '.'
      else
        map[{x, y}] = c
      end
    end
  end

  cur_pos = start_pos
  cur_dir = start_dir
  visited = Set(Tuple(Int32, Int32)).new

  loop do
    next_pos = {cur_pos[0] + vectors[cur_dir][0], cur_pos[1] + vectors[cur_dir][1]}
    pos_value = map[next_pos]?
    if pos_value == '#'
      cur_dir = (cur_dir + 1) % 4
    elsif pos_value == '.'
      cur_pos = next_pos
      visited << cur_pos
    else
      break
    end
  end

  visited.each do |pos|
    cloned_map = map.clone
    cloned_map[pos] = '#'

    cur_pos = start_pos
    cur_dir = start_dir
    visited_with_dir = Set(Tuple(Tuple(Int32, Int32), Int32)).new

    loop do
      next_pos = {cur_pos[0] + vectors[cur_dir][0], cur_pos[1] + vectors[cur_dir][1]}
      pos_value = cloned_map[next_pos]?

      if visited_with_dir.includes?({next_pos, cur_dir})
        count += 1
        break
      elsif pos_value == '#'
        cur_dir = (cur_dir + 1) % 4
      elsif pos_value == '.'
        cur_pos = next_pos
        visited_with_dir << {cur_pos, cur_dir}
      else
        break
      end
    end
  end

  count
end

test_input = <<-INPUT
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
INPUT

raise "Part 1 failed" unless count_distinct_visited_positions(test_input) == 41
raise "Part 2 failed" unless count_positions_for_obstructions(test_input) == 6

if ARGV.size > 0
  input = ARGV[0]
  puts count_distinct_visited_positions(input)
  puts count_positions_for_obstructions(input)
end
