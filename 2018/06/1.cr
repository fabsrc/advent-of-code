def find_largest_area_size(input)
  coordinates = input.lines.map{ |l| l.split(", ").map(&.to_i) }
  min_x, max_x = coordinates.minmax_of(&.[0])
  min_y, max_y = coordinates.minmax_of(&.[1])
  locations = {} of {Int32, Int32} => Array(Int32)

  min_y.upto max_y do |y|
    min_x.upto max_x do |x|
      distances = coordinates.map{ |c| (c[0] - x).abs + (c[1] - y).abs }
      min_distance = distances.min
      areas = distances.map_with_index{ |d, i| d == min_distance ? i : nil  }.compact
      locations[{x, y}] = areas
    end
  end

  inifinte_areas = locations.map{ |coords, areas| 
    areas if [min_x, max_x].includes?(coords[0]) && [min_y, max_y].includes?(coords[1])
  }.compact.flatten.uniq

  filtered_locations = locations.values.reject{ |areas|
    areas.size > 1 || inifinte_areas.includes?(areas[0])
  }.flatten

  filtered_locations.uniq.max_of{ |a| filtered_locations.count(a) }
end

raise "" unless find_largest_area_size("1, 1
1, 6
8, 3
3, 4
5, 5
8, 9") === 17
p find_largest_area_size(ARGV[0]) if ARGV.size > 0
