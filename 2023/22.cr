# https://adventofcode.com/2023/day/22

# Part 1
def get_number_of_disintegratable_bricks(snapshot_input : String) : Int32
  bricks = snapshot_input.lines.map do |line|
    s, e = line.split("~").map(&.split(",").map(&.to_i))
    {s[0], s[1], s[2], e[0], e[1], e[2]}
  end

  max_zs = Hash(Tuple(Int32, Int32), Int32).new(0)

  bricks
    .sort_by!(&.[2])
    .map! { |(sx, sy, sz, ex, ey, ez)|
      brick_area = (sx..ex).to_a.cartesian_product((sy..ey).to_a)
      max_z = brick_area.max_of { |a| max_zs[a] } + 1
      brick_area.each { |a| max_zs[a] = max_z + ez - sz }

      {sx, sy, max_z, ex, ey, max_z + ez - sz}
    }
    .count { |brick|
      max_zs.clear

      bricks.none? do |(sx, sy, sz, ex, ey, ez)|
        next if brick == {sx, sy, sz, ex, ey, ez}

        brick_area = (sx..ex).to_a.cartesian_product((sy..ey).to_a)
        max_z = brick_area.max_of { |a| max_zs[a] } + 1
        brick_area.each { |a| max_zs[a] = max_z + ez - sz }

        max_z < sz
      end
    }
end

# Part 2
def get_number_of_falling_bricks(snapshot_input : String) : Int32
  bricks = snapshot_input.lines.map do |line|
    s, e = line.split("~").map(&.split(",").map(&.to_i))
    {s[0], s[1], s[2], e[0], e[1], e[2]}
  end

  max_zs = Hash(Tuple(Int32, Int32), Int32).new(0)

  bricks
    .sort_by!(&.[2])
    .map! { |(sx, sy, sz, ex, ey, ez)|
      brick_area = (sx..ex).to_a.cartesian_product((sy..ey).to_a)
      max_z = brick_area.max_of { |a| max_zs[a] } + 1
      brick_area.each { |a| max_zs[a] = max_z + ez - sz }

      {sx, sy, max_z, ex, ey, max_z + ez - sz}
    }
    .sum { |brick|
      max_zs.clear

      bricks.count do |(sx, sy, sz, ex, ey, ez)|
        next if brick == {sx, sy, sz, ex, ey, ez}

        brick_area = (sx..ex).to_a.cartesian_product((sy..ey).to_a)
        max_z = brick_area.max_of { |a| max_zs[a] } + 1
        brick_area.each { |a| max_zs[a] = max_z + ez - sz }

        max_z < sz
      end
    }
end

test_input = <<-INPUT
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
INPUT

raise "Part 1 failed" unless get_number_of_disintegratable_bricks(test_input) == 5
raise "Part 2 failed" unless get_number_of_falling_bricks(test_input) == 7

if ARGV.size > 0
  input = ARGV[0]
  puts get_number_of_disintegratable_bricks(input)
  puts get_number_of_falling_bricks(input)
end
