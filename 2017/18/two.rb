require 'thread'

def duet(input)
  lines = input.lines.map do |line|
    instruction, *vals = line.split
    [instruction.to_sym, *vals.map! { |val| val.match?(/-?\d+/) ? val.to_i : val.to_sym }]
  end

  queues = [Queue.new, Queue.new]
  threads = []
  count = 0

  0.upto(1) do |i|
    threads << Thread.new do
      registers = { p: i }
      idx = 0
      loop do
        instruction, x, y = lines[idx]
        resolve = ->(val) { val.is_a?(Integer) ? val : registers[val] }

        case instruction
        when :snd
          count += 1 if i == 1
          queues[1 - i] << resolve[x]
        when :set
          registers[x] = resolve[y]
        when :add
          registers[x] += resolve[y]
        when :mul
          registers[x] *= resolve[y]
        when :mod
          registers[x] %= resolve[y]
        when :rcv
          value = queues[i].pop until value
          registers[x] = value
        when :jgz
          idx += resolve[y] - 1 if resolve[x] > 0
        end

        idx += 1
      end
    end
  end

  threads.each do |thread|
    thread.join 0.5
  end

  count
end

puts(duet("snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d") == 3)

puts(duet("set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 826
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19"))
