OPCODES = [
  :addr,
  :addi,
  :mulr,
  :muli,
  :banr,
  :bani,
  :borr,
  :bori,
  :setr,
  :seti,
  :gtir,
  :gtri,
  :gtrr,
  :eqir,
  :eqri,
  :eqrr
]

def do_operation(reg, op, a, b, c)
  reg[c] = case op
    when :addr
      reg[a] + reg[b]
    when :addi
      reg[a] + b
    when :mulr
      reg[a] * reg[b]
    when :muli
      reg[a] * b
    when :banr
      reg[a] & reg[b]
    when :bani
      reg[a] & b
    when :borr
      reg[a] | reg[b]
    when :bori
      reg[a] | b
    when :setr
      reg[a]
    when :seti
      a
    when :gtir
      a > reg[b] ? 1 : 0
    when :gtri
      reg[a] > b ? 1 : 0
    when :gtrr
      reg[a] > reg[b] ? 1 : 0
    when :eqir
      a == reg[b] ? 1 : 0
    when :eqri
      reg[a] == b ? 1 : 0
    when :eqrr
      reg[a] == reg[b] ? 1 : 0
    end
end

def samples_behaving_like_three_or_more_opcodes(input)
  samples, _ = input.split("\n\n\n\n")
  samples.delete(',')
    .scan(/Before:\s+\[(.*)\]\n(.*)\nAfter:\s+\[(.*)\]/)
    .map{ |sample| sample.map{ |s| s.split.map(&:to_i) } }
    .count{ |before, instruction, after|
      _, a, b, c = instruction
      OPCODES.sum{ |opcode|
        registers = before.dup
        do_operation(registers, opcode, a, b, c)
        registers == after ? 1 : 0
      } >= 3
    }
end

fail unless samples_behaving_like_three_or_more_opcodes("Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]") == 1
puts samples_behaving_like_three_or_more_opcodes(ARGV[0]) if ARGV[0]
