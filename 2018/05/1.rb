def reduce_polymer(input)
  regexs = ('a'..'z').flat_map{ |c| [/#{c}#{c.upcase}/, /#{c.upcase}#{c}/] }

  last_size = nil
  loop do
    last_size = input.size
    regexs.each do |re|
      input = input.gsub(re, "")
    end
    return input.size if last_size === input.size
  end
end

fail unless reduce_polymer("dabAcCaCBAcCcaDA") == 1
p reduce_polymer(ARGV[0]) if ARGV[0]
