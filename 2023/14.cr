# https://adventofcode.com/2023/day/14

# Part 1
def get_total_load_on_north_support_beams(mirror_notes : String) : Int32
  platform = Hash(Tuple(Int32, Int32), Char).new

  row_count = mirror_notes.lines.size
  mirror_notes.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      platform[{x, y}] = char if char != '.'
    end
  end

  platform
    .select { |_, v| v == 'O' }
    .keys
    .sort_by { |(x, y)| y }
    .each { |(x, y)|
      until platform[{x, y - 1}]? || y == 0
        platform.delete({x, y})
        y -= 1
        platform[{x, y}] = 'O'
      end
    }

  platform.select { |_, v| v == 'O' }.keys.sum { |(x, y)| row_count - y }
end

# Part 2
def get_total_load_on_north_support_beams_after_spin_cycles(mirror_notes : String) : Int32
  platform = Hash(Tuple(Int32, Int32), Char).new

  row_count = mirror_notes.lines.size
  mirror_notes.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      platform[{x, y}] = char if char != '.'
    end
  end

  loads = Array(Int32).new

  200.times do
    platform
      .select { |_, v| v == 'O' }
      .keys
      .sort_by { |(x, y)| y }
      .each { |(x, y)|
        until platform[{x, y - 1}]? || y == 0
          platform.delete({x, y})
          y -= 1
          platform[{x, y}] = 'O'
        end
      }

    platform
      .select { |_, v| v == 'O' }
      .keys
      .sort_by { |(x, y)| x }
      .each { |(x, y)|
        until platform[{x - 1, y}]? || x == 0
          platform.delete({x, y})
          x -= 1
          platform[{x, y}] = 'O'
        end
      }

    platform
      .select { |_, v| v == 'O' }
      .keys
      .sort_by { |(x, y)| y }
      .reverse
      .each { |(x, y)|
        until platform[{x, y + 1}]? || y == row_count - 1
          platform.delete({x, y})
          y += 1
          platform[{x, y}] = 'O'
        end
      }

    platform
      .select { |_, v| v == 'O' }
      .keys
      .sort_by { |(x, y)| x }
      .reverse
      .each { |(x, y)|
        until platform[{x + 1, y}]? || x == row_count - 1
          platform.delete({x, y})
          x += 1
          platform[{x, y}] = 'O'
        end
      }

    loads << platform.select { |_, v| v == 'O' }.keys.sum { |(x, y)| row_count - y }
  end

  cycle_start = 0
  cycle = loads

  (1..loads.size).each_with_index(2) do |i, idx|
    base = loads[i..]
    res = (2..base.size).any? do |z|
      if base[0, z]? == base[z, z]?
        cycle = base[0, z]
        true
      end
    end
    cycle_start = idx
    break if res
  end

  cycle[(1_000_000_000 - cycle_start) % cycle.size]
end

test_input = <<-INPUT
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
INPUT

raise "Part 1 failed" unless get_total_load_on_north_support_beams(test_input) == 136
raise "Part 2 failed" unless get_total_load_on_north_support_beams_after_spin_cycles(test_input) == 64

if ARGV.size > 0
  input = ARGV[0]
  puts get_total_load_on_north_support_beams(input)
  puts get_total_load_on_north_support_beams_after_spin_cycles(input)
end
