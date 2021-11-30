# :christmas_tree::calendar: Advent of Code 2021

## Run solutions

```sh
# $1: Day of the calendar
export AOC_COOKIE="session=<session cookie here>"
function aoc {
  curl "https://adventofcode.com/2021/day/$1/input" -s --cookie $AOC_COOKIE
}

# Example
ruby 01.rb "$(aoc 1)"
```
