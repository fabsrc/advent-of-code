# https://adventofcode.com/2023/day/19

# Part 1
def get_sum_of_accepted_rating_numbers(workflow_input : String) : Int32
  workflow_lines, part_rating_lines = workflow_input.split("\n\n")

  workflows = Hash(String, Hash(Tuple(String, String, Int32), String)).new

  workflow_lines.each_line do |line|
    name = line[/^\w+/]
    rules = line[/{(.+)}/, 1].split(',')

    workflows[name] = Hash(Tuple(String, String, Int32), String).new

    rules.each do |rule|
      cond, *target = rule.split(':')
      part, op, number = cond.partition(/[<>]/)

      if target.empty?
        workflows[name][{"", "", 0}] = cond
        next
      end

      workflows[name][{part, op, number.to_i}] = target.first
    end
  end

  part_rating_lines.lines.sum do |line|
    parts = line[/{(.*)}/, 1].split(',').map(&.split('=')).to_h.transform_values(&.to_i)
    current = "in"

    until current == "A" || current == "R"
      workflows[current].each do |(part, op, number), target|
        if part == "" ||
           op == ">" && parts[part] > number ||
           op == "<" && parts[part] < number
          current = target
          break
        end
      end
    end

    current == "A" ? parts.values.sum : 0
  end
end

# Part 2
def get_number_of_distinct_combinations(workflow_input : String) : Int64
  workflow_lines, part_rating_lines = workflow_input.split("\n\n")

  workflows = Hash(String, Hash(Tuple(String, String, Int32), String)).new

  workflow_lines.each_line do |line|
    name = line[/^\w+/]
    rules = line[/{(.+)}/, 1].split(',')

    workflows[name] = Hash(Tuple(String, String, Int32), String).new

    rules.each do |rule|
      cond, *target = rule.split(':')
      part, op, number = cond.partition(/[<>]/)

      if target.empty?
        workflows[name][{"", "", 0}] = cond
        next
      end

      workflows[name][{part, op, number.to_i}] = target.first
    end
  end

  ranges_size = ->(ranges : Hash(String, Range(Int32, Int32))) : Int64 {
    ranges.values.product(&.size.to_i64)
  }

  count_combinations = uninitialized String, Hash(String, Range(Int32, Int32)) -> Int64
  count_combinations = ->(current : String, ranges : Hash(String, Range(Int32, Int32))) : Int64 do
    result = 0_i64

    workflows[current].each do |cond, target|
      part, op, number = cond

      if part == ""
        if target == "A"
          result += ranges_size.call(ranges)
        elsif target != "R"
          result += count_combinations.call(target, ranges)
        end
      else
        part_range = ranges[part]

        if op == ">"
          if part_range.end > number
            new_ranges = ranges.dup
            new_ranges[part] = ([part_range.begin, number + 1].max)..part_range.end

            if target == "A"
              result += ranges_size.call(new_ranges)
            elsif target != "R"
              result += count_combinations.call(target, new_ranges)
            end
          end

          ranges[part] = part_range.begin..number
        elsif op == "<"
          if part_range.begin < number
            new_ranges = ranges.dup
            new_ranges[part] = (part_range.begin)..([part_range.end, number - 1].min)

            if target == "A"
              result += ranges_size.call(new_ranges)
            elsif target != "R"
              result += count_combinations.call(target, new_ranges)
            end
          end

          ranges[part] = number..(part_range.end)
        end
      end
    end

    result
  end

  initial_ranges = {"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}
  count_combinations.call("in", initial_ranges)
end

test_input = <<-INPUT
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
INPUT

raise "Part 1 failed" unless get_sum_of_accepted_rating_numbers(test_input) == 19114
raise "Part 2 failed" unless get_number_of_distinct_combinations(test_input) == 167409079868000

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_accepted_rating_numbers(input)
  puts get_number_of_distinct_combinations(input)
end
