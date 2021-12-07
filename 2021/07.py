# https://adventofcode.com/2021/day/7
import sys
from functools import cache

# Part 1


def get_cheapest_outcome(positions):
    return min(
        sum(abs(possible_pos - current_pos) for current_pos in positions)
        for possible_pos in range(min(positions), max(positions))
    )


# Part 2


def get_cheapest_outcome_with_incremental_cost(positions):
    get_fuel_for_steps = cache(lambda s: sum(range(s + 1)))

    return min(
        sum(get_fuel_for_steps(abs(possible_pos - current_pos))
            for current_pos in positions)
        for possible_pos in range(min(positions), max(positions))
    )


test_positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
assert get_cheapest_outcome(test_positions) == 37, "Part 1 failed"
assert get_cheapest_outcome_with_incremental_cost(
    test_positions) == 168, "Part 2 failed"

if len(sys.argv) > 1:
    positions = [int(n) for n in sys.argv[1].split(",")]
    print(get_cheapest_outcome(positions))
    print(get_cheapest_outcome_with_incremental_cost(positions))
