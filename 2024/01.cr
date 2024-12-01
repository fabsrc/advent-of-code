# https://adventofcode.com/2024/day/1

# Part 1
def get_sum_of_distances(lines : Array(String)) : Int32
  left, right = lines.map(&.split("   ").map(&.to_i)).transpose
  left.sort.zip(right.sort).sum { |(nl, nr)| (nl - nr).abs }
end

# Part 2
def get_similarity_score(lines : Array(String)) : Int32
  left, right = lines.map(&.split("   ").map(&.to_i)).transpose
  counts = right.tally
  left.sum { |n| n * counts.fetch(n, 0) }
end

raise "Part 1 failed" unless get_sum_of_distances([
                               "3   4",
                               "4   3",
                               "2   5",
                               "1   3",
                               "3   9",
                               "3   3",
                             ]) == 11
raise "Part 2 failed" unless get_similarity_score([
                               "3   4",
                               "4   3",
                               "2   5",
                               "1   3",
                               "3   9",
                               "3   3",
                             ]) == 31

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_distances(input)
  puts get_similarity_score(input)
end
