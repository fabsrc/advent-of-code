# https://adventofcode.com/2020/day/8

def parse_instructions(input)
  input.map do |i|
    op, arg = i.split(" ")
    [op.to_sym, arg.to_i]
  end
end

# https://rosettacode.org/wiki/Cycle_detection#Ruby
def get_cycle_steps(x0)
  power = lambda = 1
  tortoise = x0
  hare = yield(x0)

  # Find lambda, the cycle length
  while tortoise != hare
    if power == lambda
      tortoise = hare
      power *= 2
      lambda = 0
    end
    hare = yield(hare)
    lambda += 1
  end

  # Find mu, the zero-based index of the start of the cycle
  hare = x0
  lambda.times { hare = yield(hare) }

  tortoise, mu = x0, 0
  while tortoise != hare
    tortoise = yield(tortoise)
    hare = yield(hare)
    mu += 1
  end

  lambda + mu
end

# Part 1
def get_accumulator_before_cycle(input)
  instructions = parse_instructions(input)
  accumulator = 0
  accumulator_list = []

  cycle_steps = get_cycle_steps(0) do |pointer|
    op, arg = instructions[pointer]
    accumulator_list << accumulator
    case op
    when :acc
      accumulator += arg
      pointer + 1
    when :jmp
      pointer + arg
    when :nop
      pointer + 1
    end
  end

  accumulator_list[cycle_steps]
end

# Part 2
def get_accumulator_after_termination(input)
  instructions = parse_instructions(input)

  instructions.each_with_index do |(op, arg), idx|
    current_instructions = instructions.dup

    if op == :jmp
      current_instructions[idx] = [:nop, arg]
    elsif op == :nop
      current_instructions[idx] = [:jmp, arg]
    else
      next
    end

    accumulator = 0

    get_cycle_steps(0) do |pointer|
      op, arg = current_instructions[pointer]
      case op
      when :acc
        accumulator += arg
        pointer + 1
      when :jmp
        pointer + arg
      when :nop
        pointer + 1
      when nil # program is terminated
        return accumulator
      end
    end
  end
end

raise "Part 1 failed" unless get_accumulator_before_cycle([
  "nop +0",
  "acc +1",
  "jmp +4",
  "acc +3",
  "jmp -3",
  "acc -99",
  "acc +1",
  "jmp -4",
  "acc +6",
]) == 5

raise "Part 2 failed" unless get_accumulator_after_termination([
  "nop +0",
  "acc +1",
  "jmp +4",
  "acc +3",
  "jmp -3",
  "acc -99",
  "acc +1",
  "jmp -4",
  "acc +6",
]) == 8

unless ARGV.empty?
  input = ARGV.first.lines
  puts get_accumulator_before_cycle(input)
  puts get_accumulator_after_termination(input)
end
