// https://adventofcode.com/2020/day/6

import Foundation.NSString

// Part 1
func getSumOfYesCounts(_ input: [String]) -> Int {
  return input
    .map { $0.filter { !$0.isNewline } }
    .reduce(0) { $0 + Set($1).count }
}

// Part 2
func getSumOfUnanimousYesCounts(_ input: [String]) -> Int {
  return input
    .map { $0.split(separator: "\n").map(Set.init) }
    .reduce(0) { $0 + $1.reduce($1[0]) { $0.intersection($1) }.count }
}

assert(getSumOfYesCounts([
  "abc",
  "a\nb\nc",
  "ab\nac",
  "a\na\na\na",
  "b",
]) == 11, "Part 1 failed")

assert(getSumOfUnanimousYesCounts([
  "abc",
  "a\nb\nc",
  "ab\nac",
  "a\na\na\na",
  "b",
]) == 6, "Part 2 failed")

if CommandLine.arguments.count > 1 {
  let input = CommandLine.arguments[1].components(separatedBy: "\n\n")
  print(getSumOfYesCounts(input))
  print(getSumOfUnanimousYesCounts(input))
}
