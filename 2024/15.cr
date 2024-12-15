# https://adventofcode.com/2024/day/15

alias Position = Tuple(Int32, Int32)
DIRECTIONS = {
  '<' => {-1, 0},
  '>' => {1, 0},
  '^' => {0, -1},
  'v' => {0, 1},
}

def move(pos : Position, movement : Char, map : Hash(Position, Char)) : Bool
  direction = DIRECTIONS[movement]
  cur_val = map[pos]
  next_pos = {pos[0] + direction[0], pos[1] + direction[1]}
  next_val = map[next_pos]

  if next_val == '.'
    map[next_pos] = cur_val
    map[pos] = '.'
    return true
  elsif next_val == 'O'
    can_move = move(next_pos, movement, map)

    if can_move
      map[next_pos] = cur_val
      map[pos] = '.'
      return true
    else
      return false
    end
  else
    return false
  end
end

def move_2(pos : Position, movement : Char, map : Hash(Position, Char)) : Bool
  direction = DIRECTIONS[movement]
  cur_val = map[pos]
  next_pos = {pos[0] + direction[0], pos[1] + direction[1]}
  next_val = map[next_pos]

  if next_val == '.'
    map[next_pos] = cur_val
    map[pos] = '.'
    return true
  elsif next_val == ']'
    can_move = move(next_pos, movement, map)

    if can_move
      map[next_pos] = cur_val
      map[pos] = '.'
      return true
    else
      return false
    end
  else
    return false
  end
end

# Part 1
def get_sum_of_final_gps_coordinates(input : String) : Int32
  map_input, movements_input = input.split("\n\n")
  map = Hash(Position, Char).new
  map_input.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      map[{x, y}] = char
    end
  end
  movements = movements_input.lines.flat_map(&.chars)

  movements.each do |movement|
    robot_pos = map.key_for('@')
    move(robot_pos, movement, map)
  end

  map.select { |_, v| v == 'O' }.sum { |(x, y), _| x + 100 * y }
end

# Part 2
def get_sum_of_final_gps_coordinates_with_wide_map(input : String) : Int32
  map_input, movements_input = input.split("\n\n")
  map = Hash(Position, Char).new

  map_input.lines.each_with_index do |line, y|
    x = 0

    line.each_char do |char|
      case char
      when '#'
        map[{x, y}] = '#'
        map[{x + 1, y}] = '#'
      when 'O'
        map[{x, y}] = '['
        map[{x + 1, y}] = ']'
      when '.'
        map[{x, y}] = '.'
        map[{x + 1, y}] = '.'
      when '@'
        map[{x, y}] = '@'
        map[{x + 1, y}] = '.'
      end

      x += 2
    end
  end
  movements = movements_input.lines.flat_map(&.chars)

  movements.each do |movement|
    7.times do |y|
      14.times do |x|
        print map[{x, y}]?
      end
      puts
    end
    puts

    robot_pos = map.key_for('@')
    move(robot_pos, movement, map)
  end

  map.select { |_, v| v == 'O' }.sum { |(x, y), _| x + 100 * y }
end

test_input = <<-INPUT
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
INPUT

test_input_2 = <<-INPUT
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
INPUT

raise "Part 1 failed" unless get_sum_of_final_gps_coordinates(test_input) == 10092
raise "Part 2 failed" unless get_sum_of_final_gps_coordinates_with_wide_map(test_input_2) == 9021

if ARGV.size > 0
  input = ARGV[0]
  puts get_sum_of_final_gps_coordinates(input)
  # puts get_sum_of_final_gps_coordinates_with_wide_map(input)
end
