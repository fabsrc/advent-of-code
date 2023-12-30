# https://adventofcode.com/2020/day/23

# Part 1
def get_small_crab_cups(input)
  cups = input.chars.map(&:to_i)
  100.times do
    current_cup = cups.first
    picked_up_cups = cups.slice!(1, 3)
    dest_cup = nil
    tmp_cup = current_cup - 1
    while dest_cup.nil?
      if tmp_cup < cups.min
        tmp_cup = cups.max
      elsif picked_up_cups.include?(tmp_cup)
        tmp_cup -= 1
      else
        dest_cup = tmp_cup
      end
    end
    cups.insert(cups.index(dest_cup) + 1, *picked_up_cups)
    cups.rotate!(cups.index(current_cup) + 1)
  end

  cups.rotate(cups.index(1)).drop(1).join
end

class Cup
  attr_accessor :next
  attr_reader :label

  def initialize(label)
    @label = label
    @next = nil
  end
end

# Part 2
def get_big_crab_cups(input)
  cups_input = input.chars.map(&:to_i)
  cups = (1..1_000_000).map { |label| Cup.new(label) }
  cups.unshift(cups.last) # Moves indexes to allow lookup by label
  [*cups_input, *((cups_input.max + 1)..1_000_000).to_a].each_cons(2) do |a, b|
    cups[a].next = cups[b]
  end
  cups.last.next = cups[cups_input.first]
  head = cups[cups_input.first]

  10_000_000.times do
    picked_up_cups = [head.next, head.next.next, head.next.next.next]
    head.next = head.next.next.next.next
    
    destination_label = head.label - 1
    destination_cup = cups[destination_label]
    while picked_up_cups.include?(destination_cup)
      destination_label -= 1
      destination_cup = cups[destination_label]
    end

    picked_up_cups.last.next = destination_cup.next
    destination_cup.next = picked_up_cups.first
    head = head.next
  end

  head = cups[1]
  (head.next.label * head.next.next.label).to_s
end

raise "Part 1 failed" unless get_small_crab_cups("389125467") == "67384529"
raise "Part 2 failed" unless get_big_crab_cups("389125467") == "149245887792"

if ARGV.size > 0
  input = ARGV.first
  puts get_small_crab_cups(input)
  puts get_big_crab_cups(input)
end
