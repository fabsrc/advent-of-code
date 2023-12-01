# https://adventofcode.com/2023/day/1

# Part 1
def get_sum_of_calibration_values(lines : Array(String)) : Int32
  lines.sum(&.chars.compact_map(&.to_i?).values_at(0, -1).join.to_i)
end

# Part 2
def get_real_sum_of_calibration_values(lines : Array(String)) : Int32
  digit_words = %w{zero one two three four five six seven eight nine}
  regex = /(?=(\d|#{digit_words[1..].join("|")}))/

  lines.sum { |line|
    line.scan(regex).values_at(0, -1).map { |d| digit_words.index(d[1]) || d[1] }.join.to_i
  }
end

raise "Part 1 failed" unless get_sum_of_calibration_values([
                               "1abc2",
                               "pqr3stu8vwx",
                               "a1b2c3d4e5f",
                               "treb7uchet",
                             ]) == 142
raise "Part 2 failed" unless get_real_sum_of_calibration_values([
                               "two1nine",
                               "eightwothree",
                               "abcone2threexyz",
                               "xtwone3four",
                               "4nineeightseven2",
                               "zoneight234",
                               "7pqrstsixteen",
                             ]) == 281

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_calibration_values(input)
  puts get_real_sum_of_calibration_values(input)
end
