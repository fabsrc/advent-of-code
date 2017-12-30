def coprocessor(input)
  lines = input.lines.map do |line|
    instruction, *vals = line.split
    [instruction.to_sym, *vals.map! { |val| val.match?(/-?\d+/) ? val.to_i : val.to_sym }]
  end

  registers = {}
  idx = 0
  count = 0
  resolve = ->(val) { val.is_a?(Integer) ? val : registers[val] }

  loop do
    instruction, x, y = lines[idx]
    y = resolve[y]
    registers[x] ||= 0

    case instruction
    when :set
      registers[x] = y
    when :sub
      registers[x] -= y
    when :mul
      registers[x] *= y
      count += 1
    when :jnz
      idx += y - 1 if resolve[x] != 0
    end

    idx += 1

    break if lines[idx].nil?
  end

  count
end

puts(coprocessor("set b 81
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23
"))
