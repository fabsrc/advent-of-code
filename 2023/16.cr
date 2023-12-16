# https://adventofcode.com/2023/day/16

DIRECTIONS = {up: {0, -1}, right: {1, 0}, down: {0, 1}, left: {-1, 0}}

# Part 1
def get_number_of_energized_tiles(contraption_input : String) : Int32
  layout = Hash(Tuple(Int32, Int32), Char).new

  contraption_input.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      layout[{x, y}] = char
    end
  end

  energized_tiles = Hash(Tuple(Int32, Int32), Set(Tuple(Int32, Int32))).new do |hash, key|
    hash[key] = Set(Tuple(Int32, Int32)).new
  end

  start_beam = uninitialized Tuple(Int32, Int32), Tuple(Int32, Int32) -> Nil
  start_beam = ->(coords : Tuple(Int32, Int32), dir : Tuple(Int32, Int32)) : Nil {
    until energized_tiles[coords].includes?(dir)
      energized_tiles[coords].add(dir)
      x, y = coords
      dx, dy = dir
      coords = {x + dx, y + dy}
      char = layout[coords]?

      case {char, dir}
      when {nil, _}
        break
      when {'/', DIRECTIONS[:right]},
           {'⧵', DIRECTIONS[:left]}
        dir = DIRECTIONS[:up]
      when {'/', DIRECTIONS[:left]},
           {'⧵', DIRECTIONS[:right]}
        dir = DIRECTIONS[:down]
      when {'/', DIRECTIONS[:down]},
           {'⧵', DIRECTIONS[:up]}
        dir = DIRECTIONS[:left]
      when {'/', DIRECTIONS[:up]},
           {'⧵', DIRECTIONS[:down]}
        dir = DIRECTIONS[:right]
      when {'|', DIRECTIONS[:right]},
           {'|', DIRECTIONS[:left]}
        start_beam.call(coords, DIRECTIONS[:down])
        start_beam.call(coords, DIRECTIONS[:up])
        break
      when {'-', DIRECTIONS[:up]},
           {'-', DIRECTIONS[:down]}
        start_beam.call(coords, DIRECTIONS[:right])
        start_beam.call(coords, DIRECTIONS[:left])
        break
      end
    end
  }

  start_beam.call({-1, 0}, DIRECTIONS[:right])

  energized_tiles.size - 1
end

# Part 2
def get_max_number_of_energized_tiles(contraption_input : String) : Int32
  layout = Hash(Tuple(Int32, Int32), Char).new

  contraption_input.lines.each_with_index do |line, y|
    line.each_char_with_index do |char, x|
      layout[{x, y}] = char
    end
  end

  starting_points = 0.upto(contraption_input.size).flat_map do |start|
    [{ {-1, start}, DIRECTIONS[:right] },
     { {start, -1}, DIRECTIONS[:down] },
     { {contraption_input.size, start}, DIRECTIONS[:left] },
     { {start, contraption_input.size}, DIRECTIONS[:up] }]
  end

  starting_points.max_of do |(start_coords, start_dir)|
    energized_tiles = Hash(Tuple(Int32, Int32), Set(Tuple(Int32, Int32))).new do |hash, key|
      hash[key] = Set(Tuple(Int32, Int32)).new
    end

    start_beam = uninitialized Tuple(Int32, Int32), Tuple(Int32, Int32) -> Nil
    start_beam = ->(coords : Tuple(Int32, Int32), dir : Tuple(Int32, Int32)) : Nil {
      until energized_tiles[coords].includes?(dir)
        energized_tiles[coords].add(dir)
        x, y = coords
        dx, dy = dir
        coords = {x + dx, y + dy}
        char = layout[coords]?

        case {char, dir}
        when {nil, _}
          break
        when {'/', DIRECTIONS[:right]},
             {'⧵', DIRECTIONS[:left]}
          dir = DIRECTIONS[:up]
        when {'/', DIRECTIONS[:left]},
             {'⧵', DIRECTIONS[:right]}
          dir = DIRECTIONS[:down]
        when {'/', DIRECTIONS[:down]},
             {'⧵', DIRECTIONS[:up]}
          dir = DIRECTIONS[:left]
        when {'/', DIRECTIONS[:up]},
             {'⧵', DIRECTIONS[:down]}
          dir = DIRECTIONS[:right]
        when {'|', DIRECTIONS[:right]},
             {'|', DIRECTIONS[:left]}
          start_beam.call(coords, DIRECTIONS[:down])
          start_beam.call(coords, DIRECTIONS[:up])
          break
        when {'-', DIRECTIONS[:up]},
             {'-', DIRECTIONS[:down]}
          start_beam.call(coords, DIRECTIONS[:right])
          start_beam.call(coords, DIRECTIONS[:left])
          break
        end
      end
    }

    start_beam.call(start_coords, start_dir)

    energized_tiles.size - 1
  end
end

test_input = <<-INPUT
.|...⧵....
|.-.⧵.....
.....|-...
........|.
..........
.........⧵
..../.⧵⧵..
.-.-/..|..
.|....-|.⧵
..//.|....
INPUT

raise "Part 1 failed" unless get_number_of_energized_tiles(test_input) == 46
raise "Part 2 failed" unless get_max_number_of_energized_tiles(test_input) == 51

if ARGV.size > 0
  input = ARGV[0]
  escaped_input = input.gsub('\\', '⧵')
  puts get_number_of_energized_tiles(escaped_input)
  puts get_max_number_of_energized_tiles(escaped_input)
end
