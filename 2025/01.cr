# https://adventofcode.com/2025/day/1

# Part 1: count_all_zero_clicks=false
# Part 2: count_all_zero_clicks=true
def get_door_password(rotations : Array(String), count_all_zero_clicks = false) : Int32
  current = 50
  zero_clicks = 0

  rotations.each do |rotation|
    dir = rotation[0] == 'L' ? -1 : 1
    dist = rotation[1..].to_i

    if count_all_zero_clicks
      dist.times do
        current = (current + dir) % 100
        zero_clicks += 1 if current == 0
      end
    else
      current = (current + dist * dir) % 100
      zero_clicks += 1 if current == 0
    end
  end

  zero_clicks
end

test_input = [
  "L68",
  "L30",
  "R48",
  "L5",
  "R60",
  "L55",
  "L1",
  "L99",
  "R14",
  "L82",
]
raise "Part 1 failed" unless get_door_password(test_input) == 3
raise "Part 2 failed" unless get_door_password(test_input, true) == 6

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_door_password(input)
  puts get_door_password(input, true)
end
