require 'set'

def find_duplicate_frequency(input)
  frequencies = Set.new
  current_frequency = 0

  input.lines.cycle { |i|
    return current_frequency unless frequencies.add?(current_frequency)
    current_frequency += i.to_i
  }
end

fail unless find_duplicate_frequency("+1\n-1") == 0
fail unless find_duplicate_frequency("+3\n+3\n+4\n-2\n-4") == 10
fail unless find_duplicate_frequency("-6\n+3\n+8\n+5\n-6") == 5
fail unless find_duplicate_frequency("+7\n+7\n-2\n-7\n-4") == 14
p find_duplicate_frequency(ARGV[0]) if ARGV[0]
