# https://adventofcode.com/2023/day/6

# Part 1
def get_product_of_winning_ways_counts(race_records : String) : Int32
  race_times, record_distances = race_records.lines.map(&.scan(/(\d+)/).map(&.[0].to_i))

  race_times.zip(record_distances).product do |(race_time, record_distance)|
    1.upto(race_time).count do |button_press_time|
      travel_time = race_time - button_press_time
      distance = travel_time * button_press_time
      distance > record_distance
    end
  end
end

# Part 2
def get_winning_ways_count_for_long_race(race_records : String) : Int32
  race_time, record_distance = race_records.lines.map(&.gsub(/\D/, "").to_i64)

  1.upto(race_time).count do |button_press_time|
    travel_time = race_time - button_press_time
    distance = travel_time * button_press_time
    distance > record_distance
  end
end

test_input = <<-INPUT
Time:      7  15   30
Distance:  9  40  200
INPUT

raise "Part 1 failed" unless get_product_of_winning_ways_counts(test_input) == 288
raise "Part 2 failed" unless get_winning_ways_count_for_long_race(test_input) == 71503

if ARGV.size > 0
  input = ARGV[0]
  puts get_product_of_winning_ways_counts(input)
  puts get_winning_ways_count_for_long_race(input)
end
