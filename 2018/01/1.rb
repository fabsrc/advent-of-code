def calculate_frequency_change(input)
  input.lines.sum(&:to_i)
end

fail unless calculate_frequency_change("+1\n+1\n+1") == 3
fail unless calculate_frequency_change("+1\n+1\n-2") == 0
fail unless calculate_frequency_change("-1\n-2\n-3") == -6
p calculate_frequency_change(ARGV[0]) if ARGV[0]
