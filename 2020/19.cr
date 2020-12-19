# https://adventofcode.com/2020/day/19

# Part 1
def get_number_of_messages_matching_rule_zero(rules : String, messages : String) : Int32
  rules = rules.lines.map { |l| l.delete("\"").split(": ") }.to_h
  rule_zero = rules["0"]

  while rule_zero.matches?(/\d+/)
    rule_zero = rule_zero.gsub(/\d+/) do |d|
      rules[d].includes?('|') ? "(#{rules[d]})" : rules[d]
    end
  end

  re = Regex.new("^#{rule_zero}$", Regex::Options::EXTENDED)
  messages.lines.count(&.matches?(re))
end

# Part 2
def get_number_of_messages_matching_rule_zero_with_loop(rules : String, messages : String) : Int32
  rules = rules.lines.map { |l| l.delete("\"").split(": ") }.to_h
  rule_zero = rules["0"]

  count = 0
  maxCount = 10
  while rule_zero.matches?(/\d+/)
    rule_zero = rule_zero.gsub(/\d+/) do |d|
      if d == "8" && (count += 1) < maxCount
        "(42 | 42 8)"
      elsif d == "11" && (count += 1) < maxCount
        "(42 31 | 42 11 31)"
      else
        rules[d].includes?('|') ? "(#{rules[d]})" : rules[d]
      end
    end
  end

  re = Regex.new("^#{rule_zero}$", Regex::Options::EXTENDED)
  messages.lines.count(&.matches?(re))
end

raise "Part 1 failed" unless get_number_of_messages_matching_rule_zero(
                               "0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: \"a\"
5: \"b\"",
                               "ababbb
bababa
abbbab
aaabbb
aaaabbb") == 2

raise "Part 2 failed" unless get_number_of_messages_matching_rule_zero_with_loop(
                               "42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: \"a\"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: \"b\"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1",
                               "abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba") == 12

if ARGV.size > 0
  rules, messages = ARGV.first.split("\n\n")
  puts get_number_of_messages_matching_rule_zero(rules, messages)
  puts get_number_of_messages_matching_rule_zero_with_loop(rules, messages)
end
