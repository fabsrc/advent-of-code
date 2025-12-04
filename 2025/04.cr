# https://adventofcode.com/2025/day/4

VECTORS = [{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}]
alias Position = Tuple(Int32, Int32)

def create_grid(input : String) : Hash(Position, Char)
  grid = {} of Position => Char

  input.lines.each_with_index do |line, y|
    line.chars.each_with_index do |c, x|
      grid[{x, y}] = c if c == '@'
    end
  end

  grid
end

# Part 1
def get_accessible_rolls_count(input : String) : Int32
  grid = create_grid(input)

  grid.count do |((x, y))|
    VECTORS.count { |(dx, dy)| grid[{x + dx, y + dy}]? } < 4
  end
end

# Part 2
def get_total_removable_rolls_count(input : String) : Int32
  grid = create_grid(input)

  count = 0

  loop do
    next_grid = grid.reject do |(x, y)|
      count += 1 if VECTORS.count { |(dx, dy)| grid[{x + dx, y + dy}]? } < 4
    end

    return count if grid == next_grid

    grid = next_grid
  end
end

test_input = <<-INPUT
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
INPUT
raise "Part 1 failed" unless get_accessible_rolls_count(test_input) == 13
raise "Part 2 failed" unless get_total_removable_rolls_count(test_input) == 43

if ARGV.size > 0
  input = ARGV[0]
  puts get_accessible_rolls_count(input)
  puts get_total_removable_rolls_count(input)
end
