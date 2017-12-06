def reallocate(input)
    memory = input.split.map(&:to_i)
    store = []
    count = 0

    until store.include?(memory.hash) do
        store << memory.hash
        count += 1
        max = memory.max
        idx = memory.index(max)
        memory[idx] = 0
        
        max.times do
            idx = idx < memory.size - 1 ? idx + 1 : 0
            memory[idx] += 1
        end
    end
    
    count
end

puts(reallocate("0 2 7 0") == 5)
puts(reallocate("4	10	4	1	8	4	9	14	5	1	14	15	0	15	3	5"))
