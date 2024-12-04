# https://adventofcode.com/2024/day/4

# Part 1
def get_xmas_count(input : String) : Int32
  horizontals = input.lines
  verticals = horizontals.map(&.chars).transpose.map(&.join)
  size = horizontals.size

  diagonals = [] of String
  (size * 2 - 2).times do |i|
    diagonal_1 = ""
    diagonal_2 = ""
    (([0, i - size + 1].max)...([size, i + 1].min)).each do |x|
      diagonal_1 = horizontals[x][i - x] + diagonal_1
      diagonal_2 = diagonal_2 + verticals[x][i - x]
    end
    diagonals << diagonal_1 << diagonal_2
  end

  [horizontals, verticals, diagonals].flatten.sum(&.scan(/(?=XMAS|SAMX)/).size)
end

# Part 2
def get_x_mas_count(input : String) : Int32
  word_search = input.lines.map(&.chars)
  count = 0

  word_search.each_with_index do |line, row|
    line.each_with_index do |char, col|
      next unless char == 'A'

      lt = word_search.dig?(row - 1, col - 1) unless (row - 1 < 0) || (col - 1 < 0)
      lb = word_search.dig?(row + 1, col - 1) unless (col - 1 < 0)
      rt = word_search.dig?(row - 1, col + 1) unless (row - 1 < 0)
      rb = word_search.dig?(row + 1, col + 1)

      count += 1 if lt == 'M' && rb == 'S' && rt == 'S' && lb == 'M' ||
                    lt == 'M' && rb == 'S' && rt == 'M' && lb == 'S' ||
                    lt == 'S' && rb == 'M' && rt == 'M' && lb == 'S' ||
                    lt == 'S' && rb == 'M' && rt == 'S' && lb == 'M'
    end
  end

  count
end

raise "Part 1 failed" unless get_xmas_count("MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX") == 18
raise "Part 2 failed" unless get_x_mas_count("MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX") == 9

if ARGV.size > 0
  input = ARGV[0]
  puts get_xmas_count(input)
  puts get_x_mas_count(input)
end
