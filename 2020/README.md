# :christmas_tree::calendar: Advent of Code 2020

## Run solutions

```sh
# $1: Day of the calendar
# $2: AOC cookie
function get_aoc_input {
  curl "https://adventofcode.com/2020/day/$1/input" -s --cookie $2
}

# Example
ruby 01.rb "$(get_aoc_input 1 the_session_cookie)"
```
