# https://adventofcode.com/2025/day/6

# Part 1
def get_grand_total_of_problems(input : String) : Int64
  rows = input.lines.map(&.split(/\s+/).reject(&.empty?))
  numbers = rows[..-2].map(&.map(&.to_i64)).transpose
  ops = rows.last
  numbers.zip(ops).sum { |(n, op)| op == "+" ? n.sum : n.product }
end

# Part 2
def get_grand_total_of_problems_right_to_left_in_columns(input : String) : Int64
  rows = input.lines.map(&.split(""))
  numbers = rows[..-2].transpose
    .map(&.join.strip)
    .slice_when { |a, b| b == "" }
    .map(&.reject(&.==("")).map(&.to_i64))
  ops = rows.last.reject(&.blank?)
  numbers.zip(ops).sum { |(n, op)| op == "+" ? n.sum : n.product }
end

test_input = <<-INPUT
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
INPUT
raise "Part 1 failed" unless get_grand_total_of_problems(test_input) == 4277556
raise "Part 2 failed" unless get_grand_total_of_problems_right_to_left_in_columns(test_input) == 3263827

if ARGV.size > 0
  input = ARGV[0]
  puts get_grand_total_of_problems(input)
  puts get_grand_total_of_problems_right_to_left_in_columns(input)
end
