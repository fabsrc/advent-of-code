# https://adventofcode.com/2023/day/4

# Part 1
def get_sum_of_card_worths(cards_input : Array(String)) : Int32
  cards_input.sum { |card_input|
    _, numbers = card_input.split(": ")
    winning_numbers, own_numbers = numbers.split(" | ").map(&.scan(/(\d+)/).map(&.[0].to_i))
    1 << (winning_numbers & own_numbers).size - 1
  }
end

# Part 2
def get_total_number_of_scratchcards(cards_input : Array(String)) : Int32
  scratchcard_counts = Array(Int32).new(cards_input.size) { 1 }

  cards_input.each_with_index { |card_input, idx|
    _, numbers = card_input.split(": ")
    winning_numbers, own_numbers = numbers.split(" | ").map(&.scan(/(\d+)/).map(&.[0].to_i))
    wins_count = (winning_numbers & own_numbers).size
    wins_count.times do |i|
      scratchcard_counts[idx + i] += scratchcard_counts[idx - 1]
    end
  }

  scratchcard_counts.sum
end

test_input = <<-INPUT
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
INPUT

raise "Part 1 failed" unless get_sum_of_card_worths(test_input.lines) == 13
raise "Part 2 failed" unless get_total_number_of_scratchcards(test_input.lines) == 30

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_card_worths(input)
  puts get_total_number_of_scratchcards(input)
end
