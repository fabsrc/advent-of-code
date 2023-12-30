# https://adventofcode.com/2021/day/14

# Part 1: Set steps to 10
# Part 2: Set steps to 40
def get_polymer_quantity_result(template, rules, steps)
  pairs = Hash.new(0).merge(template.chars.each_cons(2).tally)
  rules = rules.map { _1.delete(' -> ').chars }

  steps.times do
    new_pairs = pairs.clone
    rules.each do |a, b, i|
      new_pairs[[a, i]] += pairs[[a, b]]
      new_pairs[[i, b]] += pairs[[a, b]]
      new_pairs[[a, b]] -= pairs[[a, b]]
    end
    pairs = new_pairs
  end

  counts = Hash.new(0).merge({ template[-1] => 1 })
  pairs.each do |(el), count|
    counts[el] += count
  end

  counts.values.minmax.reduce(&:-).abs
end

test_polymers = [
  'NNCB', [
    'CH -> B',
    'HH -> N',
    'CB -> H',
    'NH -> C',
    'HB -> C',
    'HC -> B',
    'HN -> C',
    'NN -> C',
    'BH -> H',
    'NC -> B',
    'NB -> B',
    'BN -> B',
    'BB -> N',
    'BC -> B',
    'CC -> N',
    'CN -> C'
  ]
]
raise 'Part 1 failed' unless get_polymer_quantity_result(*test_polymers, 10) == 1588
raise 'Part 2 failed' unless get_polymer_quantity_result(*test_polymers, 40) == 2_188_189_693_529

unless ARGV.empty?
  template, rules = ARGV.first.split("\n\n")
  rules = rules.split("\n")
  puts get_polymer_quantity_result(template, rules, 10)
  puts get_polymer_quantity_result(template, rules, 40)
end
