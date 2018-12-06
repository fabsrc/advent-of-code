def find_largest_area_size_with_total_distance(input, total)
  coordinates = input.lines.map{ |l| l.split(", ").map(&.to_i) }
  min_x, max_x = coordinates.minmax_of(&.[0])
  min_y, max_y = coordinates.minmax_of(&.[1])
  area_size = 0

  min_y.upto max_y do |y|
    min_x.upto max_x do |x|
      sum_of_distances = coordinates.sum{ |c| (c[0] - x).abs + (c[1] - y).abs }
      area_size += sum_of_distances < total ? 1 : 0
    end
  end

  area_size
end

raise "" unless find_largest_area_size_with_total_distance("1, 1
1, 6
8, 3
3, 4
5, 5
8, 9", 32) === 16
p find_largest_area_size_with_total_distance(ARGV[0], 10000) if ARGV.size > 0
