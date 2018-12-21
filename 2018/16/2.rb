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

def identify_opcodes(input)
  samples, program = input.split("\n\n\n\n")
  opcodes_mapping = {}
  samples.delete(',')
    .scan(/Before:\s+\[(.*)\]\n(.*)\nAfter:\s+\[(.*)\]/)
    .map{ |sample| sample.map{ |s| s.split.map(&:to_i) } }
    .each do |before, instruction, after|
      op, a, b, c = instruction
      possible_opcodes = (OPCODES - opcodes_mapping.values).select{ |opcode|
        registers = before.dup
        do_operation(registers, opcode, a, b, c)
        registers == after
      }

      if possible_opcodes.size == 1
        opcodes_mapping[op] = possible_opcodes.first
      end
    end

  registers = [0, 0, 0, 0]
  program.lines
    .map{ |l| l.split.map(&:to_i) }
    .each{ |op, a, b, c|
      do_operation(registers, opcodes_mapping[op], a, b, c)
    }

  registers.first
end

puts identify_opcodes(ARGV[0]) if ARGV[0]
