# https://adventofcode.com/2025/day/5

# Part 1
def get_fresh_ids_count(input : String) : Int32
  ranges, ids = input.split("\n\n")
  ranges = ranges.lines.map do |l|
    a, b = l.split('-').map(&.to_i64)
    (a..b)
  end

  ids.lines.count { |id| ranges.any?(&.includes?(id.to_i64)) }
end

# Part 2
def get_all_fresh_ids_count_in_ranges(input : String) : Int64
  ranges = input.split("\n\n").first.lines.map(&.split('-').map(&.to_i64))

  sorted = ranges.sort_by(&.first)
  merged = [] of Array(Int64)
  current = sorted.first

  sorted.skip(1).each do |r|
    if r[0] <= current[1] + 1
      current = [current[0], {current[1], r[1]}.max]
    else
      merged << current
      current = r
    end
  end

  merged << current

  merged.sum { |(first, last)| last - first + 1}
end

test_input = <<-INPUT
3-5
10-14
16-20
12-18

1
5
8
11
17
32
INPUT
raise "Part 1 failed" unless get_fresh_ids_count(test_input) == 3
raise "Part 2 failed" unless get_all_fresh_ids_count_in_ranges(test_input) == 14

if ARGV.size > 0
  input = ARGV[0]
  puts get_fresh_ids_count(input)
  puts get_all_fresh_ids_count_in_ranges(input)
end
