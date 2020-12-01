# https://adventofcode.com/2020/day/1

# Part 1: Set `amount` to 2
# Part 2: Set `amount` to 3
def check_expense_report(entries, amount)
  entries.combination(amount).detect{ |numbers| numbers.sum == 2020 }.inject(:*)
end

raise unless check_expense_report([1721, 979, 366, 299, 675, 1456], 2) == 514579
raise unless check_expense_report([1721, 979, 366, 299, 675, 1456], 3) == 241861950

unless ARGV.empty?
  entries = ARGV.first.lines.map(&:to_i)
  puts check_expense_report(entries, 2)
  puts check_expense_report(entries, 3)
end
