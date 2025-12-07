# https://adventofcode.com/2025/day/7

alias Position = Tuple(Int32, Int32)

# Part 1
def get_tachyom_splits_count(input : String) : Int32
  manifold = {} of Position => Char
  queue = [] of Position

  input.lines.each_with_index do |line, y|
    line.chars.each_with_index do |c, x|
      manifold[{x, y}] = c
      queue << {x, y} if c == 'S'
    end
  end

  splits_count = 0

  until queue.empty?
    current_pos = queue.shift
    next_pos = {current_pos[0], current_pos[1] + 1}
    next_char = manifold[next_pos]?

    if next_char == '^'
      splits_count += 1
      queue << {next_pos[0] - 1, next_pos[1]} << {next_pos[0] + 1, next_pos[1]}
    elsif next_char == '.'
      queue << next_pos
    end

    queue.uniq!
  end

  splits_count
end

# Part 2
def get_tachyom_timelines_count(input : String) : Int64
  manifold = {} of Position => Char
  counts = Hash(Position, Int64).new { 0_i64 }
  queue = [] of Position

  input.lines.each_with_index do |line, y|
    line.chars.each_with_index do |c, x|
      manifold[{x, y}] = c
      if c == 'S'
        counts[{x, y}] = 1_i64
        queue << {x, y}
      end
    end
  end

  timelines_count = 0_i64

  until queue.empty?
    current_pos = queue.shift
    current_count = counts[current_pos]

    next_pos = {current_pos[0], current_pos[1] + 1}
    next_char = manifold[next_pos]?

    case next_char
    when '^'
      [{next_pos[0] - 1, next_pos[1]}, {next_pos[0] + 1, next_pos[1]}].each do |t|
        queue << t unless counts[t]?
        counts[t] += current_count
      end
    when '.'
      queue << next_pos unless counts[next_pos]?
      counts[next_pos] += current_count
    else
      timelines_count += current_count
    end
  end

  timelines_count
end

test_input = <<-INPUT
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
INPUT
raise "Part 1 failed" unless get_tachyom_splits_count(test_input) == 21
raise "Part 2 failed" unless get_tachyom_timelines_count(test_input) == 40

if ARGV.size > 0
  input = ARGV[0]
  puts get_tachyom_splits_count(input)
  puts get_tachyom_timelines_count(input)
end
