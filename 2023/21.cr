# https://adventofcode.com/2023/day/21

DIRECTIONS = {up: {0, -1}, right: {1, 0}, down: {0, 1}, left: {-1, 0}}

# Part 1
def get_number_of_reachable_garden_plots_after_steps(map_input : String, steps : Int32) : Int64
  map = Hash(Tuple(Int32, Int32), Char).new
  start = {0, 0}
  map_input.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      map[{x, y}] = char if char == '#'
      start = {x, y} if char == 'S'
    end
  end

  height = map_input.lines.size
  width = map_input.lines.first.size

  current_positions = [start].to_set

  steps.times do
    new_current_positions = Set(Tuple(Int32, Int32)).new

    current_positions.each do |(x, y)|
      DIRECTIONS.values.each do |(dx, dy)|
        next_position = {x + dx, y + dy}
        next_position_adjusted = {(x + dx) % (width), (y + dy) % (height)}
        new_current_positions << next_position unless map[next_position_adjusted]? == '#'
      end
    end

    current_positions = new_current_positions
  end

  current_positions.size.to_i64
end

# Part 2
def get_number_of_reachable_garden_plots_after_more_steps(map_input : String, steps : Int32) : Int64
  width = map_input.lines.first.size

  n = (steps // width).to_i64
  a0 = get_number_of_reachable_garden_plots_after_steps(map_input, width // 2)
  a1 = get_number_of_reachable_garden_plots_after_steps(map_input, width + width // 2)
  a2 = get_number_of_reachable_garden_plots_after_steps(map_input, 2 * width + width // 2)

  a0 + n * (a1 - a0 + (n - 1) * (a2 - a1 - a1 + a0) // 2)
end

test_input = <<-INPUT
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
INPUT

raise "Part 1 failed" unless get_number_of_reachable_garden_plots_after_steps(test_input, 6) == 16

if ARGV.size > 0
  input = ARGV[0]
  puts get_number_of_reachable_garden_plots_after_steps(input, 64)
  puts get_number_of_reachable_garden_plots_after_more_steps(input, 26501365)
end
