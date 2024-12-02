# https://adventofcode.com/2024/day/2

def safe_report?(report : Array(Int32)) : Bool
  diffs = report.each_cons(2).to_a.map { |(a, b)| a - b }
  (diffs.all?(&.positive?) || diffs.all?(&.negative?)) && diffs.all? { |n| (1..3).includes?(n.abs) }
end

# Part 1
def get_number_of_safe_reports(reports : Array(Array(Int32))) : Int32
  reports.count { |report| safe_report?(report) }
end

# Part 2
def get_number_of_safe_reports_with_dampener(reports : Array(Array(Int32))) : Int32
  reports.count do |report|
    safe_report?(report) || report.each_index.any? do |idx|
      report_clone = report.clone
      report_clone.delete_at(idx)
      safe_report?(report_clone)
    end
  end
end

raise "Part 1 failed" unless get_number_of_safe_reports([
                               [7, 6, 4, 2, 1],
                               [1, 2, 7, 8, 9],
                               [9, 7, 6, 2, 1],
                               [1, 3, 2, 4, 5],
                               [8, 6, 4, 4, 1],
                               [1, 3, 6, 7, 9],
                             ]) == 2
raise "Part 2 failed" unless get_number_of_safe_reports_with_dampener([
                               [7, 6, 4, 2, 1],
                               [1, 2, 7, 8, 9],
                               [9, 7, 6, 2, 1],
                               [1, 3, 2, 4, 5],
                               [8, 6, 4, 4, 1],
                               [1, 3, 6, 7, 9],
                             ]) == 4

if ARGV.size > 0
  input = ARGV[0].lines.map(&.split.map(&.to_i))
  puts get_number_of_safe_reports(input)
  puts get_number_of_safe_reports_with_dampener(input)
end
