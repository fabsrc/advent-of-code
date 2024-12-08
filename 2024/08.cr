# https://adventofcode.com/2024/day/8

struct Location
  getter x, y

  def initialize(@x : Int32, @y : Int32)
  end

  def +(other : Location)
    Location.new(@x + other.x, @y + other.y)
  end

  def -(other : Location)
    Location.new(@x - other.x, @y - other.y)
  end

  def in_range?(range : Range)
    range.includes?(@x) && range.includes?(@y)
  end
end

# Part 1
def count_unique_antinode_locations(input : String) : Int32
  valid_range = (0...input.lines.size)
  antennas = Hash(Char, Array(Location)).new { |hash, key| hash[key] = [] of Location }

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |frequency, x|
      antennas[frequency] << Location.new(x, y) if frequency != '.'
    end
  end

  antinodes = Set(Location).new

  antennas.values.each do |locations|
    locations.combinations(2).each do |(location_a, location_b)|
      distance = location_a - location_b
      antinode_a = location_a + distance
      antinode_b = location_b - distance
      antinodes << antinode_a if antinode_a.in_range?(valid_range)
      antinodes << antinode_b if antinode_b.in_range?(valid_range)
    end
  end

  antinodes.size
end

# Part 2
def count_unique_antinode_locations_with_resonant_harmonics(input : String) : Int32
  valid_range = (0...input.lines.size)
  antennas = Hash(Char, Array(Location)).new { |hash, key| hash[key] = [] of Location }

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |frequency, x|
      antennas[frequency] << Location.new(x, y) if frequency != '.'
    end
  end

  antinodes = Set(Location).new

  antennas.values.each do |locations|
    locations.combinations(2).each do |(location_a, location_b)|
      distance = location_a - location_b

      antinode_a = location_a
      loop do
        antinodes << antinode_a
        antinode_a = antinode_a + distance
        break unless antinode_a.in_range?(valid_range)
      end

      antinode_b = location_b
      loop do
        antinodes << antinode_b
        antinode_b = antinode_b - distance
        break unless antinode_b.in_range?(valid_range)
      end
    end
  end

  antinodes.size
end

test_input = <<-INPUT
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
INPUT

raise "Part 1 failed" unless count_unique_antinode_locations(test_input) == 14
raise "Part 2 failed" unless count_unique_antinode_locations_with_resonant_harmonics(test_input) == 34

if ARGV.size > 0
  input = ARGV[0]
  puts count_unique_antinode_locations(input)
  puts count_unique_antinode_locations_with_resonant_harmonics(input)
end
