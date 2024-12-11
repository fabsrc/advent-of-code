# https://adventofcode.com/2024/day/11

# Part 1: 25
# Part 2: 75
def count_stones_after_blinking(input : String, blink_count : Int32) : Int64
  stones = input.split.map { |stone| {stone.to_i64, 1_i64} }.to_h

  blink_count.times do
    next_stones = Hash(Int64, Int64).new(0)

    until stones.empty?
      stone, count = stones.shift
      digits = stone.digits.reverse

      if stone == 0
        next_stones[1_i64] += count
      elsif digits.size.even?
        left_stone = digits[0...(digits.size//2)].join.to_i64
        right_stone = digits[(digits.size//2)..digits.size].join.to_i64
        next_stones[left_stone] += count
        next_stones[right_stone] += count
      else
        next_stones[stone * 2024] += count
      end
    end

    stones = next_stones
  end

  stones.sum(&.[1])
end

raise "Part 1 failed" unless count_stones_after_blinking("125 17", 25) == 55312

if ARGV.size > 0
  input = ARGV[0]
  puts count_stones_after_blinking(input, 25)
  puts count_stones_after_blinking(input, 75)
end
