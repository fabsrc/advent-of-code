# https://adventofcode.com/2024/day/12

alias Position = Tuple(Int32, Int32)
DIRS = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]

# Part 1
def get_total_fencing_price(input : String) : Int32
  map = {} of Position => Char

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |plant, x|
      map[{x, y}] = plant
    end
  end

  plots = [] of Array(Position)

  open = map.dup

  until open.empty?
    pos, plant = open.shift
    x, y = pos
    cur_plot = [pos]

    neighbors = DIRS.map { |(dx, dy)| {x + dx, y + dy} }.select { |pos| open.has_key?(pos) }

    until neighbors.empty?
      n_pos = neighbors.shift

      nx, ny = n_pos
      n_plant = map[n_pos]?

      if plant == n_plant
        cur_plot << n_pos
        open.delete(n_pos)
        n_neighbors = DIRS.map { |(dx, dy)| {nx + dx, ny + dy} }.select { |pos| open.has_key?(pos) && !neighbors.includes?(pos) }
        neighbors += n_neighbors
      end
    end

    plots << cur_plot
  end

  plots.sum do |plot|
    plant = map[plot.first]

    sum = plot.sum do |(x, y)|
      DIRS.map { |(dx, dy)| {x + dx, y + dy} }.count { |pos| map[pos]? == nil || map[pos]? != plant }
    end

    sum * plot.size
  end
end

# Part 2
def get_total_fencing_price_with_bulk_discount(input : String) : Int32
  map = {} of Position => Char

  input.lines.each_with_index do |line, y|
    line.each_char_with_index do |plant, x|
      map[{x, y}] = plant
    end
  end

  plots = [] of Array(Position)

  open = map.dup

  until open.empty?
    pos, plant = open.shift
    x, y = pos
    cur_plot = [pos]

    neighbors = DIRS.map { |(dx, dy)| {x + dx, y + dy} }.select { |pos| open.has_key?(pos) }

    until neighbors.empty?
      n_pos = neighbors.shift
      nx, ny = n_pos
      n_plant = map[n_pos]?

      if plant == n_plant
        cur_plot << n_pos
        open.delete(n_pos)
        n_neighbors = DIRS.map { |(dx, dy)| {nx + dx, ny + dy} }.select { |pos| open.has_key?(pos) && !neighbors.includes?(pos) }
        neighbors += n_neighbors
      end
    end

    plots << cur_plot
  end

  plots.sum do |plot|
    plant = map[plot.first]

    min_x, max_x = plot.minmax_of(&.[0])
    min_y, max_y = plot.minmax_of(&.[1])

    side_counts = 0

    [-1, 1].each do |inc|
      (min_x..max_x).each do |x|
        side_counted = false

        (min_y..max_y).each do |y|
          unless plot.includes?({x, y})
            side_counted = false
            next
          end

          next_plant = map[{x + inc, y}]?

          if (next_plant.nil? || plant != next_plant) && !side_counted
            side_counts += 1
            side_counted = true
          end

          side_counted = false if next_plant == plant
        end
      end

      (min_y..max_y).each do |y|
        side_counted = false

        (min_x..max_x).each do |x|
          unless plot.includes?({x, y})
            side_counted = false
            next
          end

          next_plant = map[{x, y + inc}]?

          if (next_plant.nil? || plant != next_plant) && !side_counted
            side_counts += 1
            side_counted = true
          end

          side_counted = false if next_plant == plant
        end
      end
    end

    plot.size * side_counts
  end
end

test_input = <<-INPUT
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
INPUT

raise "Part 1 failed" unless get_total_fencing_price(test_input) == 1930
raise "Part 2 failed" unless get_total_fencing_price_with_bulk_discount(test_input) == 1206

if ARGV.size > 0
  input = ARGV[0]
  puts get_total_fencing_price(input)
  puts get_total_fencing_price_with_bulk_discount(input)
end
