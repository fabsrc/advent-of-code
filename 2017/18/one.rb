def duet(input)
  registers = {}
  lines = input.lines.map { |line| line.split(" ") }
  idx = 0
  lastPlayed = nil

  loop do
    instruction, register, value = lines[idx]
    value = value =~ /[[:alpha:]]/ ? registers[value] : value.to_i
    registers[register] ||= 0

    case instruction
    when "snd"
      lastPlayed = registers[register]
    when "set"
      registers[register] = value
    when "add"
      registers[register] += value
    when "mul"
      registers[register] *= value
    when "mod"
      registers[register] %= value
    when "rcv"
      break if registers[register] != 0      
    end
    
    if instruction == "jgz" && registers[register] > 0
      idx += value
    else
      idx += 1
    end
  end

  lastPlayed
end


puts(duet("set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2") == 4)

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