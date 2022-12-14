# https://adventofcode.com/2021/day/16

def parse_packet(packet : Array(Int32), version_sum : Int32 = 0) : {Int32, Array(Int32), Int64}
  version = packet.shift(3).join.to_i(2)
  type_id = packet.shift(3).join.to_i(2)
  version_sum += version

  if type_id == 4
    number = [] of Int64
    loop do
      start, *bits = packet.shift(5)
      number += bits
      return {version_sum, packet, number.join.to_i64(2)} if start == 0
    end
  else
    length_type_id = packet.shift(1).join.to_i(2)
    result = [] of Int64

    if length_type_id == 0
      packet_size = packet.shift(15).join.to_i(2)
      sub_packet = packet.shift(packet_size)
      until sub_packet.empty?
        version_sum, sub_packet, sub_result = parse_packet(sub_packet, version_sum)
        result << sub_result
      end
    else
      packet_count = packet.shift(11).join.to_i(2)
      packet_count.times do
        version_sum, packet, sub_result = parse_packet(packet, version_sum)
        result << sub_result
      end
    end

    case type_id
    when 0
      {version_sum, packet, result.sum}
    when 1
      {version_sum, packet, result.product}
    when 2
      {version_sum, packet, result.min}
    when 3
      {version_sum, packet, result.max}
    when 5
      {version_sum, packet, result[0] > result[1] ? 1_i64 : 0_i64}
    when 6
      {version_sum, packet, result[0] < result[1] ? 1_i64 : 0_i64}
    when 7
      {version_sum, packet, result[0] === result[1] ? 1_i64 : 0_i64}
    else
      raise "Invalid type ID"
    end
  end
end

# Part 1
def get_sum_of_version_numbers(input : String) : Int32
  packet = input.chars.map(&.to_i(16).to_s(2, precision: 4)).join.chars.map(&.to_i)
  parse_packet(packet).first
end

# Part 2
def get_bits_transmission_result(input : String) : Int64
  packet = input.chars.map(&.to_i(16).to_s(2, precision: 4)).join.chars.map(&.to_i)
  parse_packet(packet).last
end

raise "Part 1 failed" unless get_sum_of_version_numbers("8A004A801A8002F478") == 16
raise "Part 1 failed" unless get_sum_of_version_numbers("620080001611562C8802118E34") == 12
raise "Part 1 failed" unless get_sum_of_version_numbers("C0015000016115A2E0802F182340") == 23
raise "Part 1 failed" unless get_sum_of_version_numbers("A0016C880162017C3686B18A3D4780") == 31
raise "Part 2 failed" unless get_bits_transmission_result("C200B40A82") == 3
raise "Part 2 failed" unless get_bits_transmission_result("04005AC33890") == 54
raise "Part 2 failed" unless get_bits_transmission_result("880086C3E88112") == 7
raise "Part 2 failed" unless get_bits_transmission_result("CE00C43D881120") == 9
raise "Part 2 failed" unless get_bits_transmission_result("D8005AC2A8F0") == 1
raise "Part 2 failed" unless get_bits_transmission_result("F600BC2D8F") == 0
raise "Part 2 failed" unless get_bits_transmission_result("9C005AC2F8F0") == 0
raise "Part 2 failed" unless get_bits_transmission_result("9C0141080250320F1802104A08") == 1

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_version_numbers(input)
  puts get_bits_transmission_result(input)
end
