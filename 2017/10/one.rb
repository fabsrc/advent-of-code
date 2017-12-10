def hash(input, list)
  lengths = input.split(',').map(&:to_i)
  list = list.to_a
  position = 0
  skip_size = 0

  lengths.each do |length|
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

  list.first(2).inject(:*)
end

puts hash('3,4,1,5', (0..4)) == 12
puts hash('130,126,1,11,140,2,255,207,18,254,246,164,29,104,0,224', (0..255))
