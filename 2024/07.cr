# https://adventofcode.com/2024/day/7

# Part 1
def get_total_calibration_result(input : String) : Int64
  equations = input.lines.map(&.split(": ")).map { |(test_value, numbers)|
    {test_value.to_i64, numbers.split(" ").map(&.to_i64)}
  }

  equations.sum do |(test_value, numbers)|
    results = [numbers.shift]

    numbers.each do |number|
      next_results = [] of Int64

      results.each do |current_result|
        add_result = current_result + number
        multiply_result = current_result * number

        next_results << add_result if add_result <= test_value
        next_results << multiply_result if multiply_result <= test_value
      end

      results = next_results
    end

    results.includes?(test_value) ? test_value : 0_i64
  end
end

# Part 2
def get_total_calibration_result_with_concat_op(input : String) : Int64
  equations = input.lines.map(&.split(": ")).map { |(test_value, numbers)|
    {test_value.to_i64, numbers.split(" ").map(&.to_i64)}
  }

  equations.sum do |(test_value, numbers)|
    results = [numbers.shift]

    numbers.each do |number|
      next_results = [] of Int64

      results.each do |current_result|
        add_result = current_result + number
        multiply_result = current_result * number
        concat_result = current_result * (10 ** (Math.log10(number).to_i64 + 1)) + number

        next_results << add_result if add_result <= test_value
        next_results << multiply_result if multiply_result <= test_value
        next_results << concat_result if concat_result <= test_value
      end

      results = next_results
    end

    results.includes?(test_value) ? test_value : 0_i64
  end
end

test_input = <<-INPUT
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
INPUT

raise "Part 1 failed" unless get_total_calibration_result(test_input) == 3749
raise "Part 2 failed" unless get_total_calibration_result_with_concat_op(test_input) == 11387

if ARGV.size > 0
  input = ARGV[0]
  puts get_total_calibration_result(input)
  puts get_total_calibration_result_with_concat_op(input)
end
