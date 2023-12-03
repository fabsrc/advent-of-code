# https://adventofcode.com/2023/day/3

VECTORS = [
  {0, -1},
  {1, -1},
  {1, 0},
  {1, 1},
  {0, 1},
  {-1, 1},
  {-1, 0},
  {-1, -1},
]

# Part 1
def get_sum_of_part_numbers(engine_schematic : String) : Int32
  numbers = Array(Tuple(Int32, Int32, Range(Int32, Int32))).new
  symbols = Hash(Tuple(Int32, Int32), String).new

  engine_schematic.lines.each_with_index { |line, y|
    line.scan(/(?<number>\d+)|(?<symbol>[^.\d])/).each do |m|
      numbers << {m["number"].to_i, y, m.byte_begin...m.byte_end} if m["number"]?
      symbols[{m.byte_begin, y}] = m["symbol"] if m["symbol"]?
    end
  }

  part_numbers = numbers.compact_map { |number, y, x_range|
    has_adjacent_symbol = x_range.any? { |x|
      VECTORS.any? { |(vx, vy)|
        symbols.has_key?({x + vx, y + vy})
      }
    }

    number if has_adjacent_symbol
  }

  part_numbers.sum
end

# Part 2
def get_sum_of_gear_ratios(engine_schematic : String) : Int32
  numbers = Array(Tuple(Int32, Int32, Range(Int32, Int32))).new
  star_coords = Array(Tuple(Int32, Int32)).new

  engine_schematic.lines.each_with_index { |line, y|
    line.scan(/(?<number>\d+)|(?<star>\*)/).each do |m|
      numbers << {m["number"].to_i, y, m.byte_begin...m.byte_end} if m["number"]?
      star_coords << {m.byte_begin, y} if m["star"]?
    end
  }

  gear_ratios = star_coords.compact_map do |star_x, star_y|
    adjacent_numbers = numbers.select { |_, y, x_range|
      x_range.any? { |x|
        VECTORS.any? { |(vx, vy)|
          {star_x, star_y} == {x + vx, y + vy}
        }
      }
    }

    adjacent_numbers.product(&.[0]) if adjacent_numbers.size == 2
  end

  gear_ratios.sum
end

test_input = <<-INPUT
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
INPUT

raise "Part 1 failed" unless get_sum_of_part_numbers(test_input) == 4361
raise "Part 2 failed" unless get_sum_of_gear_ratios(test_input) == 467835

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_part_numbers(input)
  puts get_sum_of_gear_ratios(input)
end
