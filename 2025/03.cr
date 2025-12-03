# https://adventofcode.com/2025/day/3

# Part 1: size=2
# Part 2: size=12
def get_total_output_joltage(banks : Array(String), size = 2) : Int64
  banks.sum do |bank|
    bank = bank.chars.map(&.to_i64)
    joltage = ""

    until joltage.size == size
      max = bank.reverse.skip(size - joltage.size - 1).max
      joltage += max.to_s
      bank.shift(bank.index!(max) + 1)
    end

    joltage.to_i64
  end
end

test_input = [
  "987654321111111",
  "811111111111119",
  "234234234234278",
  "818181911112111",
]
raise "Part 1 failed" unless get_total_output_joltage(test_input) == 357
raise "Part 2 failed" unless get_total_output_joltage(test_input, 12) == 3121910778619

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_total_output_joltage(input)
  puts get_total_output_joltage(input, 12)
end
