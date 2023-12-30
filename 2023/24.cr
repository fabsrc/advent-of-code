# https://adventofcode.com/2023/day/24

# Part 1
def get_number_of_intersections_in_test_area(hailstone_note_input : String, test_area : Range(Int128, Int128)) : Int32
  hailstones = hailstone_note_input.lines.map do |line|
    line.split(" @ ").map(&.split(", ").map(&.to_i128))
  end

  res = hailstones.combinations(2).count do |(a, b)|
    a1x, a1y, a1z = a[0]
    avx, avy, avz = a[1]
    a2x, a2y, a2z = {a1x + avx, a1y + avy, a1z + avz}
    b1x, b1y, b1z = b[0]
    bvx, bvy, bvz = b[1]
    b2x, b2y, b2z = {b1x + bvx, b1y + bvy, b1z + bvz}

    a1 = a2y - a1y
    b1 = a1x - a2x
    c1 = a1 * a1x + b1 * a1y

    a2 = b2y - b1y
    b2 = b1x - b2x
    c2 = a2 * b1x + b2 * b1y

    determinant = a1 * b2 - a2 * b1

    next false if determinant == 0

    x = (b2 * c1 - b1 * c2) / determinant
    y = (a1 * c2 - a2 * c1) / determinant

    next false unless {(x - a1x).sign, (y - a1y).sign} == {avx.sign, avy.sign} &&
                      {(x - b1x).sign, (y - b1y).sign} == {bvx.sign, bvy.sign}

    test_area.includes?(x) && test_area.includes?(y)
  end
end

# Part 2
def get_sum_of_rock_coordinates(hailstone_note_input : String) : Int64
  hailstone_vectors = hailstone_note_input.lines.map do |line|
    line.split(" @ ").map(&.split(", ").map(&.to_i64))
  end

  potential_sets = {Set(Int32).new, Set(Int32).new, Set(Int32).new}

  hailstone_vectors.each_combination(2) do |(a, b)|
    potential_sets = potential_sets.map_with_index do |potential_set, idx|
      next potential_set if a[1][idx] != b[1][idx]

      new_set = Set(Int32).new
      diff = b[0][idx] - a[0][idx]

      (-1000..1000).each do |v|
        next if v == a[1][idx]
        new_set << v if diff % (v - a[1][idx]) == 0
      end

      if potential_set.empty?
        potential_set = new_set.dup
      else
        potential_set = potential_set & new_set
      end
    end
  end

  rvx, rvy, rvz = potential_sets.map(&.first)

  ap, av = hailstone_vectors[0]
  bp, bv = hailstone_vectors[1]
  apx, apy, apz = ap
  avx, avy, avz = av
  bpx, bpy, bpz = bp
  bvx, bvy, bvz = bv
  ua = (avy - rvy) / (avx - rvx)
  ub = (bvy - rvy) / (bvx - rvx)
  wa = apy - (ua*apx)
  wb = bpy - (ub*bpx)
  rpx = (wb - wa) / (ua - ub)
  rpy = (ua * rpx + wa)
  t = (rpx - apx) // (avx - rvx)
  rpz = apz + (avz - rvz) * t

  (rpx + rpy + rpz).to_i64
end

test_input = <<-INPUT
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
INPUT

raise "Part 1 failed" unless get_number_of_intersections_in_test_area(test_input, 7_i128..27_i128) == 2

if ARGV.size > 0
  input = ARGV[0]

  puts get_number_of_intersections_in_test_area(input, 200000000000000_i128..400000000000000_i128)
  puts get_sum_of_rock_coordinates(input)
end
