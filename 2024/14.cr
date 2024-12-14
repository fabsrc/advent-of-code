# https://adventofcode.com/2024/day/14

# Part 1
def get_safety_factor(input : String, width : Int32, height : Int32) : Int32
  input.lines.map { |line|
    _, x, y, vx, vy = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).not_nil!
    x = (x.to_i + vx.to_i * 100) % width
    y = (y.to_i + vy.to_i * 100) % height
    {x, y}
  }.reject { |(x, y)| x == width // 2 || y == height // 2 }
    .group_by { |(x, y)| [x < width // 2, y < height // 2] }
    .values
    .map(&.size)
    .product
end

# Part 2
def get_seconds_until_easter_egg(input : String) : Int32
  robots = input.lines.map do |line|
    _, x, y, vx, vy = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).not_nil!
    {x.to_i, y.to_i, vx.to_i, vy.to_i}
  end

  width = 101
  height = 103

  10000.times do |seconds|
    positions = Array(Tuple(Int32, Int32)).new

    robots.each do |(x, y, vx, vy)|
      positions << {(x.to_i + vx.to_i * seconds) % width, (y.to_i + vy.to_i * seconds) % height}
    end

    return seconds if positions.size == positions.uniq.size
  end

  0
end

test_input = <<-INPUT
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
INPUT

raise "Part 1 failed" unless get_safety_factor(test_input, 11, 7) == 12

if ARGV.size > 0
  input = ARGV[0]
  puts get_safety_factor(input, 101, 103)
  puts get_seconds_until_easter_egg(input)
end
