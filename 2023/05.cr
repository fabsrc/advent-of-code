# https://adventofcode.com/2023/day/5

# Part 1
def get_lowest_location_number(almanac : String) : Int64
  first, *rest = almanac.split("\n\n").map(&.gsub(/[\w\-\ ]+:\s?/, ""))
  seed_numbers = first.split.map(&.to_i64)
  maps = rest.map(&.split("\n").map(&.split.map(&.to_i64)))

  lowest_location_number = seed_numbers.max.to_i64

  seed_numbers.each do |seed_number|
    current = seed_number

    maps.each do |transforms|
      transforms.each do |(dest_start, source_start, length)|
        if current >= source_start && current < source_start + length
          current = (current - source_start) + dest_start
          break
        end
      end
    end

    lowest_location_number = current if lowest_location_number > current
  end

  lowest_location_number
end

# Part 2
def get_lowest_location_number_with_ranges(almanac : String) : Int64
  first, *rest = almanac.split("\n\n").map(&.gsub(/[\w\-\ ]+:\s?/, ""))
  seed_numbers = first.split.map(&.to_i64)
  seed_ranges = seed_numbers.in_groups_of(2, 0).map { |(a, b)| (a.to_i64)...(a + b).to_i64 }
  maps = rest.map(&.split("\n").map(&.split.map(&.to_i64)))

  lowest_location_number = seed_numbers.max.to_i64
  temp_seed_number = seed_numbers.max.to_i64

  seed_ranges.each do |seed_range|
    seed_range.step(10_000).each do |seed|
      current = seed

      maps.each do |transforms|
        transforms.each do |(dest_start, source_start, length)|
          if current >= source_start && current < source_start + length
            current = (current - source_start) + dest_start
            break
          end
        end
      end

      if lowest_location_number > current
        temp_seed_number = seed
        lowest_location_number = current
      end
    end
  end

  ((temp_seed_number - 10_000)..(temp_seed_number + 10_000)).each do |seed_number|
    next unless seed_ranges.any?(&.includes?(seed_number))
    current = seed_number

    maps.each do |transforms|
      transforms.each do |(dest_start, source_start, length)|
        if current >= source_start && current < source_start + length
          current = (current - source_start) + dest_start
          break
        end
      end
    end

    lowest_location_number = current if lowest_location_number > current
  end

  lowest_location_number
end

test_input = <<-INPUT
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
INPUT

raise "Part 1 failed" unless get_lowest_location_number(test_input) == 35
raise "Part 2 failed" unless get_lowest_location_number_with_ranges(test_input) == 46

if ARGV.size > 0
  input = ARGV[0]
  puts get_lowest_location_number(input)
  puts get_lowest_location_number_with_ranges(input)
end
