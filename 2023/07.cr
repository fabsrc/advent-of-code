# https://adventofcode.com/2023/day/7

# Part 1
def get_total_winnings(cards_input : Array(String)) : Int32
  cards_input
    .map(&.split)
    .map { |(hand, bid)|
      card_counts = hand.chars.tally.values
      strength = case card_counts.sort.reverse
                 when [5]          then 7
                 when [4, 1]       then 6
                 when [3, 2]       then 5
                 when [3, 1, 1]    then 4
                 when [2, 2, 1]    then 3
                 when [2, 1, 1, 1] then 2
                 else                   1
                 end

      cards_strength_string = hand.tr("23456789TJQKA", ('A'..'M').join)

      {bid, strength, cards_strength_string}
    }
    .sort_by { |(_, strength, cards_strength_string)| {strength, cards_strength_string} }
    .map_with_index(1) { |(bid), rank| bid.to_i * rank }
    .sum
end

# Part 2
def get_total_winnings_with_joker(cards_input : Array(String)) : Int32
  cards_input
    .map(&.split)
    .map { |(hand, bid)|
      card_counts = hand.chars.tally.reject('J').values
      joker_count = hand.count('J')

      strength = case {card_counts.sort.reverse, joker_count}
                 when {[5], 0},
                      {[4], 1},
                      {[3], 2},
                      {[2], 3},
                      {[1], 4},
                      {_, 5}
                   7
                 when {[4, 1], 0},
                      {[3, 1], 1},
                      {[2, 1], 2},
                      {[1, 1], 3},
                      {_, 4}
                   6
                 when {[3, 2], 0},
                      {[2, 2], 1}
                   5
                 when {[3, 1, 1], 0},
                      {[2, 1, 1], 1},
                      {[1, 1, 1], 2}
                   4
                 when {[2, 2, 1], 0}
                   3
                 when {[2, 1, 1, 1], 0},
                      {[1, 1, 1, 1], 1}
                   2
                 else
                   1
                 end

      cards_strength_string = hand.tr("J23456789TQKA", ('A'..'M').join)

      {bid, strength, cards_strength_string}
    }
    .sort_by { |(_, strength, cards_strength_string)| {strength, cards_strength_string} }
    .map_with_index(1) { |(bid), rank| bid.to_i * rank }
    .sum
end

test_input = <<-INPUT
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
INPUT

raise "Part 1 failed" unless get_total_winnings(test_input.lines) == 6440
raise "Part 2 failed" unless get_total_winnings_with_joker(test_input.lines) == 5905

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_total_winnings(input)
  puts get_total_winnings_with_joker(input)
end
