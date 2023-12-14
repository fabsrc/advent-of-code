# https://adventofcode.com/2023/day/12

CACHE = Hash(Tuple(String, Array(Int64)), Int64).new

def process(record : String, groups : Array(Int64)) : Int64
  CACHE.put_if_absent({record, groups}) do
    if groups.empty?
      unless record.includes?('#')
        return 1.to_i64
      else
        return 0.to_i64
      end
    end

    return 0.to_i64 if record.empty?

    next_char = record[0]
    next_group = groups[0]

    pound = ->{
      this_group = record[...next_group]
      this_group = this_group.gsub("?", "#")

      return 0.to_i64 unless this_group == "#" * next_group

      if record.size == next_group
        return groups.size == 1 ? 1.to_i64 : 0.to_i64
      end

      if record[next_group] == '?' || record[next_group] == '.'
        return process(record[(next_group + 1)..], groups[1..])
      end

      return 0.to_i64
    }

    case next_char
    when '#' then pound.call
    when '.' then process(record[1..], groups)
    when '?' then process(record[1..], groups) + pound.call
    else          0.to_i64
    end
  end
end

# Part 1
def get_sum_of_possible_arrangement_counts(records_input : Array(String)) : Int64
  records_input.sum do |row|
    records, groups = row.split
    groups = groups.split(',').map(&.to_i64)

    process(records, groups)
  end
end

# Part 2
def get_sum_of_possible_unfolded_arrangement_counts(records_input : Array(String)) : Int64
  records_input.sum do |row|
    records, groups = row.split
    groups = groups.split(',').map(&.to_i64)

    process(((records + "?") * 5).rchop, groups * 5)
  end
end

test_input = <<-INPUT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
INPUT

raise "Part 1 failed" unless get_sum_of_possible_arrangement_counts(test_input.lines) == 21
raise "Part 2 failed" unless get_sum_of_possible_unfolded_arrangement_counts(test_input.lines) == 525152

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_possible_arrangement_counts(input)
  puts get_sum_of_possible_unfolded_arrangement_counts(input)
end
