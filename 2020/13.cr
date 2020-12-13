# https://adventofcode.com/2020/day/13

require "big"

# Part 1
def get_earliest_bus(input : Array(String)) : Int32
  start_timestamp_str, bus_ids_str = input
  start_timestamp = start_timestamp_str.to_i
  bus_ids = bus_ids_str
    .split(',')
    .reject(&.==("x"))
    .map(&.to_i)

  (start_timestamp..).each do |timestamp|
    bus_ids.each do |id|
      return (timestamp - start_timestamp) * id if timestamp.divisible_by?(id)
    end
  end
end

# Part 2
def get_earliest_timestamp(input : String) : BigInt
  ids_with_offset = input
    .split(',')
    .map_with_index { |id, offset| id != "x" ? {BigInt.new(id.to_i), BigInt.new(offset)} : nil }
    .compact

  max = ids_with_offset.product(&.first)
  series = ids_with_offset.map { |(m, r)| r * max * modinv(max // m, m) // m }
  max - series.sum % max
end

# https://rosettacode.org/wiki/Modular_inverse#Crystal
def modinv(a0, m0)
  return 1 if m0 == 1
  a, m = a0, m0
  x0, inv = 0, 1
  while a > 1
    inv -= (a // m) * x0
    a, m = m, a % m
    x0, inv = inv, x0
  end
  inv += m0 if inv < 0
  inv
end

raise "Part 1 failed" unless get_earliest_bus(["939", "7,13,x,x,59,x,31,19"]) == 295
raise "Part 2 failed" unless get_earliest_timestamp("7,13,x,x,59,x,31,19") == 1068781

if ARGV.size > 0
  input = ARGV[0].split("\n")
  puts get_earliest_bus(input)
  puts get_earliest_timestamp(input[1])
end
