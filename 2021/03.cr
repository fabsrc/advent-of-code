# https://adventofcode.com/2021/day/3

# Part 1
def get_power_consumption(numbers : Array(String)) : Int32
  numbers
    .map(&.chars)
    .transpose
    .map { |n| n.minmax_by { |i| n.count(i) } }
    .transpose
    .map(&.join.to_i(2))
    .product
end

# Part 2
def get_life_support_rating(numbers : Array(String)) : Int32
  n1 = numbers.clone
  n2 = numbers.clone

  numbers.first.size.times { |i|
    counts1 = n1.tally_by(&.[i])
    n1.select!(&.[i].==(counts1.fetch('1', 0) >= counts1.fetch('0', 0) ? '1' : '0')) unless n1.size == 1

    counts2 = n2.tally_by(&.[i])
    n2.select!(&.[i].==(counts2.fetch('1', 0) >= counts2.fetch('0', 0) ? '0' : '1')) unless n2.size == 1
  }

  n1.first.to_i(2) * n2.first.to_i(2)
end

test_numbers = %w(
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
)
raise "Part 1 failed" unless get_power_consumption(test_numbers) === 198
raise "Part 2 failed" unless get_life_support_rating(test_numbers) === 230

if ARGV.size > 0
  input = ARGV[0].split("\n")
  puts get_power_consumption(input)
  puts get_life_support_rating(input)
end
