# https://adventofcode.com/2023/day/15

def hash(input : String) : Int32
  input.each_char.reduce(0) do |current_value, char|
    current_value += char.ord
    current_value *= 17
    current_value %= 256
  end
end

# Part 1
def get_sum_of_hash_results(init_sequence : String) : Int32
  steps = init_sequence.split(',')

  steps.sum { |step| hash(step) }
end

# Part 2
def get_total_focusing_power(init_sequence : String) : Int32
  steps = init_sequence.split(',')

  boxes = Array.new(256) { Hash(String, Int32).new }

  steps.each do |step|
    label, op, focal_length = step.partition(/[=-]/)
    box_no = hash(label)

    case op
    when "-"
      boxes[box_no].delete(label)
    when "="
      boxes[box_no][label] = focal_length.to_i
    end
  end

  boxes.each_with_index(1).sum do |box, box_no|
    box.each_with_index(1).sum do |(_, focal_length), slot_no|
      box_no * slot_no * focal_length
    end
  end
end

test_input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

raise "Part 1 failed" unless get_sum_of_hash_results(test_input) == 1320
raise "Part 2 failed" unless get_total_focusing_power(test_input) == 145

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_hash_results(input)
  puts get_total_focusing_power(input)
end
