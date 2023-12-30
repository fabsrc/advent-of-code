def hash(input)
  lengths = input.chars.map(&:ord) + [17, 31, 73, 47, 23]
  list = *(0..255)
  position = 0
  skip_size = 0

  lengths.cycle(64) do |length|
    sub_list = []
    index_list = []

    index = position
    length.times do
      sub_list << list[index]
      index_list << index
      index = (index + 1) % list.size
    end

    sub_list.reverse.zip(index_list).each { |val, idx| list[idx] = val }

    position = (position + length + skip_size) % list.size
    skip_size += 1
  end

  dense_hash = list.each_slice(16).map { |block| block.inject(:^) }
  dense_hash.map { |n| n.to_s(16).rjust(2, '0') }.join
end

def defrag(input)
  rows = []

  128.times do |idx|
    hash = hash(input + "-" + idx.to_s).chars.flat_map do |c|
      c.hex.to_s(2).rjust(4, '0').chars.map(&:to_i)
    end

    rows[idx] = hash
  end

  rows.join.sum
end

puts(defrag("flqrgnkx") == 8108)
puts(defrag("hwlqcszp"))
