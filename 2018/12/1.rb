def sum_of_pot_numbers(input)
  current_state = input.scan(/initial state: (.*)$/).flatten.first
  notes = input.scan(/[.#]{5} => [.#]/).map{ |m| m.split(" => ")}.to_h
  offset = 0
  
  20.times do
    temp_state = "...#{current_state}..."
    current_state = ""
    0.upto (temp_state.size - 5) do |i|
      current_pattern = temp_state[i..i+4]
      p current_pattern
      current_state += notes[current_pattern] || "."
    end
    offset -= current_state.index(/[^.]/) - 1
    current_state.gsub!(/^\.*|\.*$/, '')
  end

  current_state.chars.each_with_index.sum{ |n, idx| n == "#" ? idx - offset : 0 }
end

fail unless sum_of_pot_numbers("initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #") == 325
puts sum_of_pot_numbers(ARGV[0]) if ARGV[0]
