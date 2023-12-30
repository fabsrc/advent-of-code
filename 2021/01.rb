# https://adventofcode.com/2021/day/1

# Part 1
def get_number_of_increases(measurements)
  measurements.each_cons(2).count { _2 - _1 > 0 }
end

# Part 2
def get_number_of_increases_with_sliding_window(measurements)
  get_number_of_increases(measurements.each_cons(3).map(&:sum))
end

test_measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
raise unless get_number_of_increases(test_measurements) == 7
raise unless get_number_of_increases_with_sliding_window(test_measurements) == 5

unless ARGV.empty?
  measurements = ARGV.first.lines.map(&:to_i)
  puts get_number_of_increases(measurements)
  puts get_number_of_increases_with_sliding_window(measurements)
end
