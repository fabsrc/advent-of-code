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

puts hash('') == 'a2582a3a0e66e6e86e3812dcb672a272'
puts hash('AoC 2017') == '33efeb34ea91902bb2f59c9920caa6cd'
puts hash('1,2,3') == '3efbe78a8d82f29979031a4aa0b16a9d'
puts hash('1,2,4') == '63960835bcdc130f0b66d7ff4f6a5a8e'
puts hash('130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224')
