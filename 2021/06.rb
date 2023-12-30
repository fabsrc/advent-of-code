# https://adventofcode.com/2021/day/6

# Part 1: Set days to 80
# Part 2: Set days to 256
def get_lanternfish_count(initial_state, days)
  counts = initial_state.split(',').map(&:to_i).tally

  days.times do
    counts = counts.each_with_object(Hash.new { 0 }) do |(timer, count), new_counts|
      if timer == 0
        new_counts[8] = count
        new_counts[6] += count
      else
        new_counts[timer - 1] += count
      end
    end
  end

  counts.values.sum
end

test_initial_state = '3,4,3,1,2'
raise 'Part 1 failed' unless get_lanternfish_count(test_initial_state, 80) == 5934
raise 'Part 2 failed' unless get_lanternfish_count(test_initial_state, 256) == 26984457539

unless ARGV.empty?
  initial_state = ARGV.first
  puts get_lanternfish_count(initial_state, 80)
  puts get_lanternfish_count(initial_state, 256)
end
