# https://adventofcode.com/2023/day/9

# Part 1
def get_sum_of_extrapolated_values(oasis_report : Array(String)) : Int32
  oasis_report
    .map(&.split.map(&.to_i))
    .sum do |numbers|
      extrapolated_value = 0

      until numbers.all?(&.zero?)
        extrapolated_value += numbers.last
        numbers = numbers.each_cons_pair.to_a.map { |a, b| b - a }
      end

      extrapolated_value
    end
end

# Part 2
def get_sum_of_backwards_extrapolated_values(oasis_report : Array(String)) : Int32
  oasis_report
    .map(&.split.map(&.to_i))
    .sum do |numbers|
      extrapolated_value = 0

      until numbers.all?(&.zero?)
        extrapolated_value += numbers.first
        numbers = numbers.each_cons_pair.to_a.map { |a, b| a - b }
      end

      extrapolated_value
    end
end

test_input = <<-INPUT
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
INPUT

raise "Part 1 failed" unless get_sum_of_extrapolated_values(test_input.lines) == 114
raise "Part 2 failed" unless get_sum_of_backwards_extrapolated_values(test_input.lines) == 2

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_extrapolated_values(input)
  puts get_sum_of_backwards_extrapolated_values(input)
end
