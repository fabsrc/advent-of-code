# 🎄📆 Advent of Code 2023

## Run solutions

```sh
export AOC_COOKIE="session=<session cookie here>"
# $1: Day of the calendar
function aoc {
  curl "https://adventofcode.com/2023/day/$1/input" -s --cookie $AOC_COOKIE
}

# Example
crystal 01.cr "$(aoc 1)"
```
