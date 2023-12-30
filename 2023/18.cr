# https://adventofcode.com/2023/day/18

DIRECTIONS = {"R" => {1, 0}, "D" => {0, 1}, "L" => {-1, 0}, "U" => {0, -1}}

# Part 1
def get_area_of_lagoon(dig_plan_input : String) : Int64
  lagoon_coords = Array(Tuple(Int64, Int64)).new
  current = {0.to_i64, 0.to_i64}

  trench_count = dig_plan_input.lines.sum { |line|
    dir, count = line.split
    dx, dy = DIRECTIONS[dir]
    count = count.to_i128
    x, y = current

    lagoon_coords << current
    current = {x + dx * count, y + dy * count}
    lagoon_coords << current

    count
  }

  area = lagoon_coords.each_cons_pair.sum { |(x, y), (nx, ny)|
    (x * ny) - (nx * y)
  }

  (area + trench_count) // 2 + 1
end

# Part 2
def get_max_number_of_energized_tiles(dig_plan_input : String) : Int64
  lagoon_coords = Array(Tuple(Int64, Int64)).new
  current = {0.to_i64, 0.to_i64}

  trench_count = dig_plan_input.lines.sum { |line|
    *_, hexcode = line.split
    count = hexcode[2, 5].to_i(16)
    dx, dy = DIRECTIONS.values[hexcode[7, 1].to_i]
    x, y = current

    lagoon_coords << current
    current = {x + dx * count, y + dy * count}
    lagoon_coords << current

    count
  }

  area = lagoon_coords.each_cons_pair.sum { |(x, y), (nx, ny)|
    (x * ny) - (nx * y)
  }

  (area + trench_count) // 2 + 1
end

test_input = <<-INPUT
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
INPUT

raise "Part 1 failed" unless get_area_of_lagoon(test_input) == 62
raise "Part 2 failed" unless get_max_number_of_energized_tiles(test_input) == 952408144115

if ARGV.size > 0
  input = ARGV[0]
  puts get_area_of_lagoon(input)
  puts get_max_number_of_energized_tiles(input)
end
