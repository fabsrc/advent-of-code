# https://adventofcode.com/2024/day/3

# Part 1
def get_sum_of_mul_results(input : String) : Int32
  input.scan(/mul\((\d+),(\d+)\)/).to_a.sum { |(_, x, y)| x.to_i * y.to_i }
end

# Part 2
def get_more_accurate_sum_of_mul_results(input : String) : Int32
  sum = 0
  enabled = true

  input.scan(/mul\((\d+),(\d+)\)|don't\(\)|do\(\)/) do |match|
    case match[0]
    when "don't()"
      enabled = false
    when "do()"
      enabled = true
    else
      sum += match[1].to_i * match[2].to_i if enabled
    end
  end

  sum
end

raise "Part 1 failed" unless get_sum_of_mul_results("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))") == 161
raise "Part 2 failed" unless get_more_accurate_sum_of_mul_results("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))") == 48

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_mul_results(input)
  puts get_more_accurate_sum_of_mul_results(input)
end
