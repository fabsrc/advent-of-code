# https://adventofcode.com/2024/day/13

# Part 1: Addend 0
# Part 2: Addend 10000000000000
def get_fewest_token_count(input : String, addend = 0_i64) : Int64
  input.split("\n\n").sum do |config|
    a, b, prize = config.lines
    _, ax, ay = a.match(/X\+(\d+), Y\+(\d+)/).not_nil!
    _, bx, by = b.match(/X\+(\d+), Y\+(\d+)/).not_nil!
    _, x, y = prize.match(/X=(\d+), Y=(\d+)/).not_nil!

    ax = ax.to_i64
    ay = ay.to_i64
    bx = bx.to_i64
    by = by.to_i64
    x = x.to_i64 + addend
    y = y.to_i64 + addend

    d = ax * by - ay * bx
    d_a = x * by - y * bx
    d_b = ax * y - ay * x

    next 0_i64 unless d_a.divisible_by?(d) && d_b.divisible_by?(d)

    3_i64 * (d_a // d) + (d_b // d)
  end
end

test_input = <<-INPUT
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
INPUT

raise "Part 1 failed" unless get_fewest_token_count(test_input) == 480

if ARGV.size > 0
  input = ARGV[0]
  puts get_fewest_token_count(input)
  puts get_fewest_token_count(input, 10000000000000)
end
