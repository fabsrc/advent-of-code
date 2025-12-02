# https://adventofcode.com/2025/day/2

# Part 1
def get_invalid_id_sum(ranges : String) : Int64
  ranges.split(',').map(&.split('-').map(&.to_i64)).sum(0_i64) do |(first, last)|
    (first..last).sum(0_i64) do |id|
      id_str = id.to_s
      id_str[...(id_str.size//2)] == id_str[id_str.size//2..] ? id : 0
    end
  end
end

# Part 2
def get_invalid_id_sum_with_new_rules(ranges : String) : Int64
  ranges.split(',').map(&.split('-').map(&.to_i64)).sum(0_i64) do |(first, last)|
    (first..last).sum(0_i64) do |id|
      id_str = id.to_s
      (id_str.lchop + id_str.rchop).includes?(id_str) ? id : 0
    end
  end
end

test_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
raise "Part 1 failed" unless get_invalid_id_sum(test_input) == 1227775554
raise "Part 2 failed" unless get_invalid_id_sum_with_new_rules(test_input) == 4174379265

if ARGV.size > 0
  input = ARGV[0]
  puts get_invalid_id_sum(input)
  puts get_invalid_id_sum_with_new_rules(input)
end
