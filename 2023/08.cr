# https://adventofcode.com/2023/day/8

# Part 1
def get_number_of_steps(network_input : String) : Int32
  instruction_string, node_list = network_input.split("\n\n")
  instructions = instruction_string.tr("LR", "01").chars.map(&.to_i)

  nodes = node_list.lines
    .map { |line|
      node, left, right = line.gsub(/[=(),]/, "").split
      {node, {left, right}}
    }
    .to_h

  current_node = "AAA"
  steps = 0

  instructions.cycle do |instruction|
    current_node = nodes[current_node][instruction]
    steps += 1

    return steps if current_node === "ZZZ"
  end
end

# Part 2
def get_number_of_steps_for_ghosts(network_input : String) : Int64
  instruction_string, node_list = network_input.split("\n\n")
  instructions = instruction_string.tr("LR", "01").chars.map(&.to_i)

  nodes = node_list.lines
    .map { |line|
      node, left, right = line.gsub(/[=(),]/, "").split
      {node, {left, right}}
    }
    .to_h

  current_nodes = nodes.select(&.ends_with?('A')).keys
  steps = 0
  result = 1.to_i64

  instructions.cycle do |instruction|
    steps += 1

    current_nodes = current_nodes.compact_map do |current_node|
      next_node = nodes[current_node][instruction]

      if next_node.ends_with?("Z")
        result = result.lcm(steps)
        nil
      else
        next_node
      end
    end

    return result if current_nodes.empty?
  end
end

test_input_1 = <<-INPUT
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
INPUT

test_input_2 = <<-INPUT
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
INPUT

test_input_3 = <<-INPUT
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
INPUT

raise "Part 1 failed" unless get_number_of_steps(test_input_1) == 2
raise "Part 1 failed" unless get_number_of_steps(test_input_2) == 6
raise "Part 2 failed" unless get_number_of_steps_for_ghosts(test_input_3) == 6

if ARGV.size > 0
  input = ARGV[0]
  puts get_number_of_steps(input)
  puts get_number_of_steps_for_ghosts(input)
end
