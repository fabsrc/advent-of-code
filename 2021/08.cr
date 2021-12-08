# https://adventofcode.com/2021/day/8

# Part 1
def count_distinguishable_digits(lines : Array(String)) : Int32
  lines.flat_map(&.split(" | ").last.split(" "))
    .tally_by(&.size).select([2, 3, 4, 7]).values.sum
end

# Part 2
def get_decoded_output_value_sum(lines : Array(String)) : Int32
  data = lines.map(&.split(" | ").map(&.split(" ")))
  digit_lookup_by_count = {2 => 1, 3 => 7, 4 => 4, 7 => 8}

  data.sum do |(signals, outputs)|
    segments = Hash(Char, Char).new
    digits = Hash(Int32, Set(Char)).new { Set(Char).new }
    signals = signals.map(&.chars.to_set)
    signals = signals.reject do |signal|
      digit = digit_lookup_by_count.[signal.size]?
      if digit
        digits[digit] = signal
        true
      end
    end

    segments['a'] = (digits[7] - digits[1]).first

    signals.each do |s|
      res = s - segments.values ^ digits[4]
      if res.size == 1
        segments['g'] = res.first
        break
      end
    end

    signals.each do |s|
      res = s - segments.values ^ digits[1]
      if res.size == 1
        segments['d'] = res.first
        break
      end
    end

    segments['e'] = (digits[8] - digits[4] - segments.values).first
    segments['b'] = (digits[4] - digits[1] - segments.values).first

    signals.each do |s|
      res = s - segments.values
      digits[6] = s if s.size == 6 && res.size == 1
    end

    segments['c'] = (digits[8] - digits[6]).first
    segments['f'] = (('a'..'g').to_set - segments.values).first

    digits[2] = segments.select(['a', 'c', 'd', 'e', 'g']).values.to_set
    digits[3] = segments.select(['a', 'c', 'd', 'f', 'g']).values.to_set
    digits[5] = segments.select(['a', 'b', 'd', 'f', 'g']).values.to_set
    digits[9] = segments.select(['a', 'b', 'c', 'd', 'f', 'g']).values.to_set
    digits[0] = segments.select(['a', 'b', 'c', 'e', 'f', 'g']).values.to_set

    inverted_digits = digits.invert
    outputs.map { |o| inverted_digits[o.chars.to_set] }.join.to_i
  end
end

test_lines = [
  "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
  "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
  "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
  "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
  "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
  "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
  "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
  "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
  "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
  "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce",
]
raise "Part 1 failed" unless count_distinguishable_digits(test_lines) === 26
raise "Part 2 failed" unless get_decoded_output_value_sum(test_lines) === 61229

if ARGV.size > 0
  lines = ARGV[0].split("\n")
  puts count_distinguishable_digits(lines)
  puts get_decoded_output_value_sum(lines)
end
