# https://adventofcode.com/2020/day/24

class Tile
  def_equals_and_hash @x, @y, @z
  def_clone
  getter? black = false

  def initialize(@x = 0, @y = 0, @z = 0)
    @neighbor_tiles = Set(Tile).new
  end

  def +(t : Tuple(Int32, Int32, Int32)) : Tile
    @x += t[0]
    @y += t[1]
    @z += t[2]
    self
  end

  def flip
    @black = !@black
  end

  def white? : Bool
    !@black
  end

  def create_neighbors(floor : Hash(Tile, Tile))
    if @neighbor_tiles.empty?
      [
        self.clone + {-1, +1, 0}, # e
        self.clone + {-1, 0, +1}, # se
        self.clone + {0, -1, +1}, # sw
        self.clone + {+1, -1, 0}, # w
        self.clone + {+1, 0, -1}, # nw
        self.clone + {0, +1, -1}, # ne
      ].each do |neighbor_tile|
        unless existing_tile = floor[neighbor_tile]?
          floor[neighbor_tile] = neighbor_tile
          existing_tile = neighbor_tile
        end

        @neighbor_tiles << existing_tile
      end
    end
  end

  def needs_flipping? : Bool
    black_neighbor_tiles = @neighbor_tiles.count(&.black?)

    if black? && (black_neighbor_tiles == 0 || black_neighbor_tiles > 2)
      true
    elsif white? && black_neighbor_tiles == 2
      true
    else
      false
    end
  end
end

# Part 1
def get_number_of_black_tiles(tile_directions : Array(String)) : Int32
  floor = [] of Tile
  tile_directions.each do |directions|
    new_tile = Tile.new
    directions.scan(/(e|se|sw|w|nw|ne)/).each do |direction|
      case direction[0]?
      when "e"  then new_tile + {-1, +1, 0}
      when "se" then new_tile + {-1, 0, +1}
      when "sw" then new_tile + {0, -1, +1}
      when "w"  then new_tile + {+1, -1, 0}
      when "nw" then new_tile + {+1, 0, -1}
      when "ne" then new_tile + {0, +1, -1}
      end
    end
    current_tile = floor.find { |t| t == new_tile }
    unless current_tile
      floor << new_tile
      current_tile = new_tile
    end
    current_tile.flip
  end
  floor.count(&.black?)
end

# Part 2
def get_number_of_black_tiles_after_100_days(tile_directions : Array(String)) : Int32
  floor = {} of Tile => Tile
  tile_directions.each do |directions|
    new_tile = Tile.new
    directions.scan(/(e|se|sw|w|nw|ne)/).each do |direction|
      case direction[0]?
      when "e"  then new_tile + {-1, +1, 0}
      when "se" then new_tile + {-1, 0, +1}
      when "sw" then new_tile + {0, -1, +1}
      when "w"  then new_tile + {+1, -1, 0}
      when "nw" then new_tile + {+1, 0, -1}
      when "ne" then new_tile + {0, +1, -1}
      end
    end
    unless current_tile = floor[new_tile]?
      floor[new_tile] = new_tile
      current_tile = new_tile
    end
    current_tile.create_neighbors(floor)
    current_tile.flip
  end

  100.times do
    floor.values.each(&.create_neighbors(floor))
    floor.values.select(&.needs_flipping?).each(&.flip)
  end

  floor.values.count(&.black?)
end

raise "Part 1 failed" unless get_number_of_black_tiles([
                               "sesenwnenenewseeswwswswwnenewsewsw",
                               "neeenesenwnwwswnenewnwwsewnenwseswesw",
                               "seswneswswsenwwnwse",
                               "nwnwneseeswswnenewneswwnewseswneseene",
                               "swweswneswnenwsewnwneneseenw",
                               "eesenwseswswnenwswnwnwsewwnwsene",
                               "sewnenenenesenwsewnenwwwse",
                               "wenwwweseeeweswwwnwwe",
                               "wsweesenenewnwwnwsenewsenwwsesesenwne",
                               "neeswseenwwswnwswswnw",
                               "nenwswwsewswnenenewsenwsenwnesesenew",
                               "enewnwewneswsewnwswenweswnenwsenwsw",
                               "sweneswneswneneenwnewenewwneswswnese",
                               "swwesenesewenwneswnwwneseswwne",
                               "enesenwswwswneneswsenwnewswseenwsese",
                               "wnwnesenesenenwwnenwsewesewsesesew",
                               "nenewswnwewswnenesenwnesewesw",
                               "eneswnwswnwsenenwnwnwwseeswneewsenese",
                               "neswnwewnwnwseenwseesewsenwsweewe",
                               "wseweeenwnesenwwwswnew",
                             ]
                             ) == 10
raise "Part 2 failed" unless get_number_of_black_tiles_after_100_days([
                               "sesenwnenenewseeswwswswwnenewsewsw",
                               "neeenesenwnwwswnenewnwwsewnenwseswesw",
                               "seswneswswsenwwnwse",
                               "nwnwneseeswswnenewneswwnewseswneseene",
                               "swweswneswnenwsewnwneneseenw",
                               "eesenwseswswnenwswnwnwsewwnwsene",
                               "sewnenenenesenwsewnenwwwse",
                               "wenwwweseeeweswwwnwwe",
                               "wsweesenenewnwwnwsenewsenwwsesesenwne",
                               "neeswseenwwswnwswswnw",
                               "nenwswwsewswnenenewsenwsenwnesesenew",
                               "enewnwewneswsewnwswenweswnenwsenwsw",
                               "sweneswneswneneenwnewenewwneswswnese",
                               "swwesenesewenwneswnwwneseswwne",
                               "enesenwswwswneneswsenwnewswseenwsese",
                               "wnwnesenesenenwwnenwsewesewsesesew",
                               "nenewswnwewswnenesenwnesewesw",
                               "eneswnwswnwsenenwnwnwwseeswneewsenese",
                               "neswnwewnwnwseenwseesewsenwsweewe",
                               "wseweeenwnesenwwwswnew",
                             ]
                             ) == 2208

if ARGV.size > 0
  tile_directions = ARGV.first.lines
  puts get_number_of_black_tiles(tile_directions)
  puts get_number_of_black_tiles_after_100_days(tile_directions)
end
