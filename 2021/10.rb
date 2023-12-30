# https://adventofcode.com/2021/day/10

# Part 1
def get_syntax_error_score(lines)
  brackets = %w|( ) [ ] { } < >|.each_slice(2).to_h
  score_table = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }
  score = 0

  lines.each do |line|
    stack = []

    line.chars.each do |char|
      if brackets.keys.include?(char)
        stack << brackets[char]
      elsif stack.pop != char
        score += score_table[char]
        break
      end
    end
  end

  score
end

# Part 2
def get_middle_autocomplete_score(lines)
  brackets = %w|( ) [ ] { } < >|.each_slice(2).to_h
  score_table = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }
  scores = []

  lines.each do |line|
    stack = []
    line_corrupt = false

    line.chars.each do |char|
      if brackets.keys.include?(char)
        stack << brackets[char]
      elsif stack.pop != char
        line_corrupt = true
        break
      end
    end

    next if line_corrupt

    scores << stack.reverse.inject(0) do |score, c|
      score * 5 + score_table[c]
    end
  end

  scores.sort[scores.size / 2]
end

test_lines = [
  '[({(<(())[]>[[{[]{<()<>>',
  '[(()[<>])]({[<{<<[]>>(',
  '{([(<{}[<>[]}>{[]{[(<()>',
  '(((({<>}<{<{<>}{[]{[]{}',
  '[[<[([]))<([[{}[[()]]]',
  '[{[{({}]{}}([{[{{{}}([]',
  '{<[[]]>}<{[{[{[]{()[[[]',
  '[<(<(<(<{}))><([]([]()',
  '<{([([[(<>()){}]>(<<{{',
  '<{([{{}}[<[[[<>{}]]]>[]]'
]
raise 'Part 1 failed' unless get_syntax_error_score(test_lines) == 26_397
raise 'Part 2 failed' unless get_middle_autocomplete_score(test_lines) == 288_957

unless ARGV.empty?
  lines = ARGV.first.split("\n")
  puts get_syntax_error_score(lines)
  puts get_middle_autocomplete_score(lines)
end
