# https://adventofcode.com/2020/day/9

using Combinatorics

# Part 1
function get_invalid_number(input, n=25)
    current_number = input[n + 1]
    sums_of_number_pairs = map(sum, combinations(input[1:n], 2))

    if !(current_number in sums_of_number_pairs)
        return current_number
    end

    return get_invalid_number(input[2:end], n)
end

# Part 2
function get_encryption_weakness(input, n=25)
    invalid_number = get_invalid_number(input, n)

    for i in 1:length(input), j in 2:length(input)
        current_subset = input[i:j]

        if sum(current_subset) == invalid_number
            return minimum(current_subset) + maximum(current_subset)
        end
    end
end

get_invalid_number([
  35,
  20,
  15,
  25,
  47,
  40,
  62,
  55,
  65,
  95,
  102,
  117,
  150,
  182,
  127,
  219,
  299,
  277,
  309,
  576
], 5) != 127 && error("Part 1 failed")

get_encryption_weakness([
  35,
  20,
  15,
  25,
  47,
  40,
  62,
  55,
  65,
  95,
  102,
  117,
  150,
  182,
  127,
  219,
  299,
  277,
  309,
  576
], 5) != 62 && error("Part 2  failed")

if length(ARGS) > 0
    input = map(x -> parse(Int64, x), split(ARGS[1], '\n'))
    println(get_invalid_number(input))
    println(get_encryption_weakness(input))
end
