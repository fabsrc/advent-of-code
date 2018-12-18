def sum_of_pot_numbers(input)
  current_state = input.scan(/initial state: (.*)$/).flatten.first
  notes = input.scan(/[.#]{5} => [.#]/).map{ |m| m.split(" => ")}.to_h
  offset = 0
  last_sum = 0
  last_diff = 0
  gen_at_cycle = nil
  
  50_000_000_000.times do |gen|
    temp_state = "...#{current_state}..."
    current_state = ""
    0.upto (temp_state.size - 5) do |i|
      current_pattern = temp_state[i..i+4]
      current_state += notes[current_pattern] || "."
    end
    offset -= current_state.index(/[^.]/) - 1
    current_state.gsub!(/^\.*|\.*$/, '')

    sum = current_state.chars.each_with_index.sum{ |n, idx| n == "#" ? idx - offset : 0 }
    diff = sum - last_sum
    if diff == last_diff
      gen_at_cycle = gen
      break
    end
    last_diff, last_sum = diff, sum
  end

  (50_000_000_000 - gen_at_cycle) * last_diff + last_sum
end

puts sum_of_pot_numbers(ARGV[0]) if ARGV[0]
