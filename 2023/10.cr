# https://adventofcode.com/2023/day/10

# Part 1
def get_steps_to_farthest_point(area_scan : String) : Int32
  map = Hash(Tuple(Int32, Int32), Char).new
  start = {0, 0}

  area_scan.lines.each_with_index { |line, y|
    line.chars.each_with_index { |char, x|
      map[{x, y}] = char if char != '.'
      start = {x, y} if char == 'S'
    }
  }

  current_vector = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}].find! { |(vx, vy)|
    next_item = map[{start[0] + vx, start[1] + vy}]?

    (vx.positive? && ['-', 'J'].includes?(next_item)) ||
      (vx.negative? && ['-', 'F'].includes?(next_item)) ||
      (vy.positive? && ['|', 'J'].includes?(next_item)) ||
      (vy.negative? && ['|', 'F'].includes?(next_item))
  }

  current_pos = start
  steps = 0

  loop do
    steps += 1
    x, y = current_pos
    vx, vy = current_vector

    current_pos = {x + vx, y + vy}
    current_vector = case {vx, vy, map[current_pos]?}
                     when {.positive?, _, '-'},
                          {_, .positive?, 'L'},
                          {_, .negative?, 'F'}
                       {1, 0}
                     when {.positive?, _, 'J'},
                          {.negative?, _, 'L'},
                          {_, .negative?, '|'}
                       {0, -1}
                     when {.positive?, _, '7'},
                          {.negative?, _, 'F'},
                          {_, .positive?, '|'}
                       {0, 1}
                     when {.negative?, _, '-'},
                          {_, .positive?, 'J'},
                          {_, .negative?, '7'}
                       {-1, 0}
                     else
                       current_vector
                     end

    break if current_pos == start
  end

  steps // 2
end

def is_left_of?(a : Tuple(Int32, Int32), b : Tuple(Int32, Int32), x : Int32, y : Int32)
  if a[1] <= b[1]
    if y <= a[1] || y > b[1] || x >= a[0] && x >= b[0]
      false
    elsif x < a[0] && x < b[0]
      true
    end
  else
    is_left_of?(b, a, x, y)
  end
end

# Part 2
def get_number_of_enclosed_tiles(area_scan : String) : Int32
  map = Hash(Tuple(Int32, Int32), Char).new
  start = {0, 0}

  area_scan.lines.each_with_index { |line, y|
    line.chars.each_with_index { |char, x|
      map[{x, y}] = char
      start = {x, y} if char == 'S'
    }
  }

  current_vector = [{0, -1}, {1, 0}, {0, 1}, {-1, 0}].find! { |(vx, vy)|
    x, y = start
    next_item = map[{x + vx, y + vy}]?

    (vx.positive? && ['-', 'J'].includes?(next_item)) ||
      (vx.negative? && ['-', 'F'].includes?(next_item)) ||
      (vy.positive? && ['|', 'J'].includes?(next_item)) ||
      (vy.negative? && ['|', 'F'].includes?(next_item))
  }

  current_pos = start
  loop_coords = [current_pos]

  loop do
    x, y = current_pos
    vx, vy = current_vector
    current_pos = {x + vx, y + vy}
    loop_coords << current_pos

    current_vector = case {vx, vy, map[current_pos]?}
                     when {.positive?, _, '-'},
                          {_, .positive?, 'L'},
                          {_, .negative?, 'F'}
                       {1, 0}
                     when {.positive?, _, 'J'},
                          {.negative?, _, 'L'},
                          {_, .negative?, '|'}
                       {0, -1}
                     when {.positive?, _, '7'},
                          {.negative?, _, 'F'},
                          {_, .positive?, '|'}
                       {0, 1}
                     when {.negative?, _, '-'},
                          {_, .positive?, 'J'},
                          {_, .negative?, '7'}
                       {-1, 0}
                     else
                       current_vector
                     end

    break if current_pos == start
  end

  coords_to_check = map.keys - loop_coords
  corners = loop_coords.reject { |(x, y)| ['-', '|'].includes?(map[{x, y}]) }

  coords_to_check.count { |(x, y)|
    corners.each_cons_pair.to_a.count { |(a, b)|
      is_left_of?(a, b, x, y)
    }.odd?
  }
end

test_input_1 = <<-INPUT
.....
.S-7.
.|.|.
.L-J.
.....
INPUT

test_input_2 = <<-INPUT
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
INPUT

test_input_3 = <<-INPUT
..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
..........
INPUT

test_input_4 = <<-INPUT
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
INPUT

test_input_5 = <<-INPUT
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
INPUT

raise "Part 1 failed" unless get_steps_to_farthest_point(test_input_1) == 4
raise "Part 1 failed" unless get_steps_to_farthest_point(test_input_2) == 8
raise "Part 2 failed" unless get_number_of_enclosed_tiles(test_input_3) == 4
raise "Part 2 failed" unless get_number_of_enclosed_tiles(test_input_4) == 8
raise "Part 2 failed" unless get_number_of_enclosed_tiles(test_input_5) == 10

if ARGV.size > 0
  input = ARGV[0]
  puts get_steps_to_farthest_point(input)
  puts get_number_of_enclosed_tiles(input)
end
