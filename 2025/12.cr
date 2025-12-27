# https://adventofcode.com/2025/day/12

# Part 1
def get_fitted_regions_count(input : String, factor = 9) : Int32
  lines = input.split("\n\n").last.lines

  lines.count do |line|
    region, shapes = line.split(": ")
    area = region.split("x").map(&.to_i).product
    shapes_sum = shapes.split(" ").sum { |v| factor * v.to_i }
    area >= shapes_sum
  end
end

test_input = <<-INPUT
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
INPUT
raise "Part 1 failed" unless get_fitted_regions_count(test_input, 8.5) == 2

if ARGV.size > 0
  input = ARGV[0]
  puts get_fitted_regions_count(input)
end
