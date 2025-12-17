# https://adventofcode.com/2025/day/9

alias Position = Tuple(Int128, Int128)

# Part 1
def get_largest_rectangle_area_size(input : String) : Int128
  red_tiles = input.lines.map do |line|
    x, y = line.split(",")
    {x.to_i128, y.to_i128}
  end

  red_tiles.combinations(2).max_of do |((x1, y1), (x2, y2))|
    (x1 - x2 + 1).abs * (y1 - y2 + 1).abs
  end
end

# Part 2
def get_largest_rectangle_area_size_with_green_tiles(input : String) : Int128
  red_tiles = input.lines.map do |line|
    x, y = line.split(",")
    {x.to_i128, y.to_i128}
  end

  xs = red_tiles.map(&.[0]).uniq.sort
  ys = red_tiles.map(&.[1]).uniq.sort

  x_map = {} of Int128 => Int128
  xs.each_with_index { |x, i| x_map[x] = i }

  y_map = {} of Int128 => Int128
  ys.each_with_index { |y, i| y_map[y] = i }

  compressed_red = red_tiles.map { |x, y| {x_map[x], y_map[y]} }

  width = xs.size
  height = ys.size

  grid = Array.new(height) { Array.new(width, '.') }

  compressed_red.each do |cx, cy|
    grid[cy][cx] = '#'
  end

  compressed_red.each_with_index do |(cx1, cy1), i|
    cx2, cy2 = compressed_red[(i + 1) % compressed_red.size]

    if cx1 == cx2
      (Math.min(cy1, cy2)..Math.max(cy1, cy2)).each do |cy|
        grid[cy][cx1] = '#'
      end
    elsif cy1 == cy2
      (Math.min(cx1, cx2)..Math.max(cx1, cx2)).each do |cx|
        grid[cy1][cx] = '#'
      end
    end
  end

  inside_point = nil.as({Int128, Int128}?)

  (0...height).each do |cy|
    break if inside_point
    (0...width).each do |cx|
      next unless grid[cy][cx] == '.'

      transitions = 0_i128
      prev = '.'
      cx.downto(0) do |i|
        cur = grid[cy][i]
        transitions += 1 if cur != prev
        prev = cur
      end

      if transitions.odd?
        inside_point = {cx, cy}
        break
      end
    end
  end

  if inside_point
    stack = [inside_point.not_nil!]

    until stack.empty?
      cx, cy = stack.pop
      next unless cx >= 0 && cx < width && cy >= 0 && cy < height
      next unless grid[cy][cx] == '.'

      grid[cy][cx] = 'X'
      stack << {cx + 1, cy}
      stack << {cx - 1, cy}
      stack << {cx, cy + 1}
      stack << {cx, cy - 1}
    end
  end

  largest_area = 0_i128

  red_tiles.each_with_index do |(x1, y1), i|
    cx1, cy1 = x_map[x1], y_map[y1]

    red_tiles[(i + 1)...red_tiles.size].each do |x2, y2|
      cx2, cy2 = x_map[x2], y_map[y2]

      actual_width = (x2 - x1).abs + 1
      actual_height = (y2 - y1).abs + 1
      area = actual_width * actual_height

      next if area <= largest_area

      min_cx = Math.min(cx1, cx2)
      max_cx = Math.max(cx1, cx2)
      min_cy = Math.min(cy1, cy2)
      max_cy = Math.max(cy1, cy2)

      enclosed = true

      (min_cx..max_cx).each do |cx|
        if grid[min_cy][cx] == '.' || grid[max_cy][cx] == '.'
          enclosed = false
          break
        end
      end

      if enclosed
        (min_cy..max_cy).each do |cy|
          if grid[cy][min_cx] == '.' || grid[cy][max_cx] == '.'
            enclosed = false
            break
          end
        end
      end

      largest_area = area if enclosed
    end
  end

  largest_area
end

test_input = <<-INPUT
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
INPUT
raise "Part 1 failed" unless get_largest_rectangle_area_size(test_input) == 50
raise "Part 2 failed" unless get_largest_rectangle_area_size_with_green_tiles(test_input) == 24

if ARGV.size > 0
  input = ARGV[0]
  puts get_largest_rectangle_area_size(input)
  puts get_largest_rectangle_area_size_with_green_tiles(input)
end
