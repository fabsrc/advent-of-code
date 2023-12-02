# https://adventofcode.com/2023/day/2

# Part 1
def get_sum_of_possible_game_ids(game_records : Array(String)) : Int32
  game_records.sum { |record|
    game_id = record[/^Game (\d+)/, 1].to_i
    grabs = record.scan(/((\d+) (blue|red|green))/)
    max = {"red" => 12, "green" => 13, "blue" => 14}

    next 0 if grabs.any? { |(_, _, amount, color)| amount.to_i > max[color] }

    game_id
  }
end

# Part 2
def get_sum_of_power_of_minimum_set_of_cubes(game_records : Array(String)) : Int32
  game_records.sum { |record|
    grabs = record.scan(/((\d+) (blue|red|green))/)
    max = {"red" => 0, "green" => 0, "blue" => 0}

    grabs.each do |(_, _, amount, color)|
      max[color] = amount.to_i if amount.to_i > max[color]
    end

    max.values.product
  }
end

test_input = [
  "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
]

raise "Part 1 failed" unless get_sum_of_possible_game_ids(test_input) == 8
raise "Part 2 failed" unless get_sum_of_power_of_minimum_set_of_cubes(test_input) == 2286

if ARGV.size > 0
  input = ARGV[0].lines
  puts get_sum_of_possible_game_ids(input)
  puts get_sum_of_power_of_minimum_set_of_cubes(input)
end
