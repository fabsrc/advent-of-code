# https://adventofcode.com/2023/day/13

# Part 1
def get_summarized_number(lava_notes : String) : Int32
  patterns = lava_notes.split("\n\n")

  row_count = 0
  col_count = 0

  patterns.each do |pattern|
    row_mirror = 0
    col_mirror = 0

    rows = pattern.lines.map(&.chars)
    cols = pattern.lines.map(&.chars).transpose

    (1..rows.size - 1).each do |y|
      match = rows[0, y].reverse.zip?(rows[y, rows.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
      row_mirror = y if match
    end

    (1..cols.size - 1).each do |y|
      match = cols[0, y].reverse.zip?(cols[y, cols.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
      col_mirror = y if match
    end

    row_count += row_mirror
    col_count += col_mirror
  end

  row_count * 100 + col_count
end

# Part 2
def get_summarized_number_with_smudge_fix(lava_notes : String) : Int32
  patterns = lava_notes.split("\n\n")

  row_count = 0
  col_count = 0

  patterns.each do |pattern|
    old_row_mirror = 0
    old_col_mirror = 0

    rows = pattern.lines.map(&.chars)
    cols = pattern.lines.map(&.chars).transpose

    (1...rows.size).each do |y|
      match = rows[0, y].reverse.zip?(rows[y, rows.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
      old_row_mirror = y if match
    end

    (1...cols.size).each do |y|
      match = cols[0, y].reverse.zip?(cols[y, cols.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
      old_col_mirror = y if match
    end

    new_row_mirror = 0
    new_col_mirror = 0

    pattern.size.times do |n|
      temp_pattern = pattern.dup

      if temp_pattern[n] == '.'
        temp_pattern = temp_pattern.sub(n, '#')
      elsif temp_pattern[n] == '#'
        temp_pattern = temp_pattern.sub(n, '.')
      else
        next
      end

      rows = temp_pattern.lines.map(&.chars)
      cols = temp_pattern.lines.map(&.chars).transpose

      (1...rows.size).each do |y|
        match = rows[0, y].reverse.zip?(rows[y, rows.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
        new_row_mirror = y if match && y != old_row_mirror
      end

      (1...cols.size).each do |y|
        match = cols[0, y].reverse.zip?(cols[y, cols.size]).reject { |(a, b)| a.nil? || b.nil? }.all? { |(a, b)| a == b }
        new_col_mirror = y if match && y != old_col_mirror
      end
    end

    col_count += new_col_mirror
    row_count += new_row_mirror
  end

  row_count * 100 + col_count
end

test_input = <<-INPUT
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
INPUT

raise "Part 1 failed" unless get_summarized_number(test_input) == 405
raise "Part 2 failed" unless get_summarized_number_with_smudge_fix(test_input) == 400

if ARGV.size > 0
  input = ARGV[0]
  puts get_summarized_number(input)
  puts get_summarized_number_with_smudge_fix(input)
end
