# https://adventofcode.com/2025/day/8

alias JunctionBox = Tuple(Int64, Int64, Int64)

# Part 1
def get_product_of_three_largest_circuit_sizes(input : String, connections_count = 10) : Int32
  junction_boxes = input.lines.map do |line|
    x, y, z = line.split(",")
    JunctionBox.new(x.to_i64, y.to_i64, z.to_i64)
  end

  circuits = junction_boxes.map { |jb| [jb] }

  sorted_connections = junction_boxes.combinations(2).sort_by { |((x1, y1, z1), (x2, y2, z2))|
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2)
  }

  connections_count.times do
    a, b = sorted_connections.shift

    a_circuit = circuits.find!(&.includes?(a))
    b_circuit = circuits.find!(&.includes?(b))

    next if a_circuit == b_circuit

    a_circuit.concat(circuits.delete(b_circuit).not_nil!)
  end

  circuits.map(&.size).sort.last(3).product
end

# Part 2
def get_product_of_last_connected_junction_boxes_x_coordinates(input : String) : Int64
  junction_boxes = input.lines.map do |line|
    x, y, z = line.split(",")
    JunctionBox.new(x.to_i64, y.to_i64, z.to_i64)
  end

  circuits = junction_boxes.map { |jb| [jb] }

  sorted_connections = junction_boxes.combinations(2).sort_by { |((x1, y1, z1), (x2, y2, z2))|
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2)
  }

  loop do
    a, b = sorted_connections.shift

    a_circuit = circuits.find!(&.includes?(a))
    b_circuit = circuits.find!(&.includes?(b))

    next if a_circuit == b_circuit

    a_circuit.concat(circuits.delete(b_circuit).not_nil!)

    return a[0] * b[0] if circuits.size == 1
  end
end

test_input = <<-INPUT
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
INPUT
raise "Part 1 failed" unless get_product_of_three_largest_circuit_sizes(test_input) == 40
raise "Part 2 failed" unless get_product_of_last_connected_junction_boxes_x_coordinates(test_input) == 25272

if ARGV.size > 0
  input = ARGV[0]
  puts get_product_of_three_largest_circuit_sizes(input, 1000)
  puts get_product_of_last_connected_junction_boxes_x_coordinates(input)
end
