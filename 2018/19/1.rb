def do_operation(reg, op, a, b, c)
  reg[c] = case op
    when :addr; reg[a] + reg[b]
    when :addi; reg[a] + b
    when :mulr; reg[a] * reg[b]
    when :muli; reg[a] * b
    when :banr; reg[a] & reg[b]
    when :bani; reg[a] & b
    when :borr; reg[a] | reg[b]
    when :bori; reg[a] | b
    when :setr; reg[a]
    when :seti; a
    when :gtir; a > reg[b] ? 1 : 0
    when :gtri; reg[a] > b ? 1 : 0
    when :gtrr; reg[a] > reg[b] ? 1 : 0
    when :eqir; a == reg[b] ? 1 : 0
    when :eqri; reg[a] == b ? 1 : 0
    when :eqrr; reg[a] == reg[b] ? 1 : 0
    end
end

def background_process(input)
  ip_binding, *lines = input.lines()
  ip_binding = ip_binding.split[1].to_i
  instructions = lines.map(&:split).map{ |l| [l.first.to_sym, *l[1..4].map(&:to_i)] }
  registers = [0, 0, 0, 0, 0, 0]
  ip = 0
  loop do
    return registers[0] unless (op, a, b, c = instructions[ip])
    registers[ip_binding] = ip
    do_operation(registers, op, a, b, c)
    ip = registers[ip_binding]
    ip += 1
  end
end

fail unless background_process("#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5") == 6
puts background_process(ARGV[0]) if ARGV[0]
