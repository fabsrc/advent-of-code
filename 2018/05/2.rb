module PolymerReducer
  @regexs = ('a'..'z').flat_map{ |c| [/#{c}#{c.upcase}/, /#{c.upcase}#{c}/] }

  def self.reduce_polymer(input)
    last_size = nil
    loop do
      last_size = input.size
      @regexs.each do |re|
        input = input.gsub(re, "")
      end
      return input.size if last_size === input.size
    end
  end

  def self.find_shortest_polymer(input)
    ('a'..'z').map{ |c| reduce_polymer(input.gsub(/#{c}/i, "")) }.min
  end
end

fail unless PolymerReducer.find_shortest_polymer("dabAcCaCBAcCcaDA") == 4
p PolymerReducer.find_shortest_polymer(ARGV[0]) if ARGV[0]
