# https://adventofcode.com/2024/day/5

def correct_update?(rules : Array(Array(Int32)), update : Array(Int32), & : (Int32, Int32) -> Nil) : Bool
  rules.all? { |(l, r)|
    l_idx = update.index(l)
    r_idx = update.index(r)

    next true if l_idx.nil? || r_idx.nil?

    yield l_idx, r_idx if l_idx > r_idx

    l_idx < r_idx
  }
end

# Part 1
def get_sum_of_correct_middle_page_numbers(input : String) : Int32
  rules, updates = input.split("\n\n")
  rules = rules.lines.map(&.split("|").map(&.to_i))
  updates = updates.lines.map(&.split(",").map(&.to_i))

  updates
    .select { |update| correct_update?(rules, update) { } }
    .sum { |update| update[update.size // 2] }
end

# Part 2
def get_sum_of_fixed_middle_page_numbers(input : String) : Int32
  rules, updates = input.split("\n\n")
  rules = rules.lines.map(&.split("|").map(&.to_i))
  updates = updates.lines.map(&.split(",").map(&.to_i))
  sum = 0

  updates.each do |update|
    rules_for_update = rules.select { |rule| (rule & update).size == 2 }

    correct = correct_update?(rules_for_update, update) { }

    until correct
      correct = correct_update?(rules_for_update, update) { |l_idx, r_idx|
        update.swap(l_idx, r_idx)
      }

      sum += update[update.size // 2] if correct
    end
  end

  sum
end

test_input = <<-INPUT
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
INPUT

raise "Part 1 failed" unless get_sum_of_correct_middle_page_numbers(test_input) == 143
raise "Part 2 failed" unless get_sum_of_fixed_middle_page_numbers(test_input) == 123

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_correct_middle_page_numbers(input)
  puts get_sum_of_fixed_middle_page_numbers(input)
end
