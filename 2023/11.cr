# https://adventofcode.com/2023/day/11

# Part 1 - expansion_factor = 2
# Part 2 - expansion_factor = 1_000_000
def get_sum_of_shortest_galaxy_paths(image_input : String, expansion_factor = 2) : Int64
  galaxies = Array(Tuple(Int64, Int64)).new

  cols_with_expansion = image_input
    .lines
    .map(&.chars)
    .transpose
    .map_with_index { |col, idx| col.includes?('#') ? nil : idx }

  y_exp = 0

  image_input
    .lines
    .each_with_index do |line, y|
      y_exp += expansion_factor - 1 unless line.includes?('#')
      x_exp = 0

      line.each_char_with_index do |char, x|
        x_exp += expansion_factor - 1 if cols_with_expansion.includes?(x)

        galaxies << {x.to_i64 + x_exp, y.to_i64 + y_exp} if char == '#'
      end
    end

  galaxies
    .combinations(2)
    .map { |(a, b)| (b[0] - a[0]).abs + (b[1] - a[1]).abs }
    .sum
end

test_input = <<-INPUT
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
INPUT

raise "Part 1 failed" unless get_sum_of_shortest_galaxy_paths(test_input) == 374
raise "Part 2 failed" unless get_sum_of_shortest_galaxy_paths(test_input, 100) == 8410

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_shortest_galaxy_paths(input)
  puts get_sum_of_shortest_galaxy_paths(input, 1_000_000)
end
