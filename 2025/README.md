# 🎄📆 Advent of Code 2025

## Run solutions

```sh
export AOC_COOKIE="session=<session cookie here>"
function aoc {
  local day=$1
  curl "https://adventofcode.com/2025/day/$day/input" -s --cookie $AOC_COOKIE
}

# Example
crystal 01.cr "$(aoc 1)"
```
