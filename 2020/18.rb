# https://adventofcode.com/2020/day/18

module MonkeyPatch
  refine Integer do
    # Monkey patch "-" as it has the same precedence as "+"
    def -(operand)
      self * operand
    end

    # Monkey patch "&" as it has a lower precedence than "+"
    def &(operand)
      self * operand
    end
  end
end

module AoC
  using MonkeyPatch

  # Part 1
  def self.get_sum_of_results_with_same_precedence(input)
    input.sum { |i| eval(i.gsub("*", "-")) }
  end

  # Part 2
  def self.get_sum_of_results_with_switched_precedence(input)
    input.sum { |i| eval(i.gsub("*", "&")) }
  end
end

raise "Part 1 failed" unless AoC.get_sum_of_results_with_same_precedence([
  "2 * 3 + (4 * 5)",
  "5 + (8 * 3 + 9 + 3 * 4 * 3)",
  "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
  "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2",
]) == 26335
raise "Part 2 failed" unless AoC.get_sum_of_results_with_switched_precedence([
  "2 * 3 + (4 * 5)",
  "5 + (8 * 3 + 9 + 3 * 4 * 3)",
  "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
  "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2",
]) == 693891

if ARGV.size > 0
  input = ARGV.first.lines
  puts AoC.get_sum_of_results_with_same_precedence(input)
  puts AoC.get_sum_of_results_with_switched_precedence(input)
end
