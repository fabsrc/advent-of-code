# https://adventofcode.com/2020/day/15

# Part 1: Set number to 2020
# Part 2: Set number to 30000000
def get_spoken_number(input, number)
  starting_numbers = input.split(",").map(&:to_i)
  store = starting_numbers.map.with_index(1) { |n, i| [n, [i]] }.to_h

  (starting_numbers.size + 1..number).inject(starting_numbers.last) do |current_number, n|
    l1, l2 = store[current_number]&.last(2)

    if l1.nil? || l2.nil?
      current_number = 0
    else
      current_number = l2 - l1
    end

    (store[current_number] ||= []) << n
    current_number
  end
end

raise "Part 1 failed" unless get_spoken_number("0,3,6", 2020) == 436
raise "Part 2 failed" unless get_spoken_number("0,3,6", 30000000) == 175594

unless ARGV.empty?
  input = ARGV.first
  puts get_spoken_number(input, 2020)
  puts get_spoken_number(input, 30000000)
end
