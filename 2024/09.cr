# https://adventofcode.com/2024/day/9

# Part 1
def get_filesystem_checksum(input : String) : Int64
  disk_map = [] of Int64 | Nil
  id_number = 0_i64

  input.each_char_with_index do |c, idx|
    count = c.to_i64
    if idx.even?
      disk_map += [id_number] * count
      id_number += 1
    else
      disk_map += [nil] * count
    end
  end

  spaces = disk_map.map_with_index { |n, idx| {n, idx} }.select { |(n)| n.nil? }

  spaces.each do |(_, idx)|
    break if idx > disk_map.size

    cur = disk_map.pop?
    while cur.nil?
      cur = disk_map.pop?
    end

    disk_map[idx] = cur
  end

  disk_map.map_with_index { |n, idx| (n || 0_i64) * idx.to_i64 }.sum
end

# Part 2
def get_filesystem_checksum_with_new_method(input : String) : Int64
  files = [] of Tuple(Int64, Range(Int64, Int64))
  free_space = [] of Range(Int64, Int64)
  id_number = 0_i64
  cur_idx = 0

  input.each_char_with_index do |c, idx|
    count = c.to_i64
    if idx.even?
      files << {id_number, cur_idx.to_i64..(cur_idx.to_i64 + c.to_i64 - 1)}
      id_number += 1
    else
      free_space << (cur_idx.to_i64..(cur_idx.to_i64 + c.to_i64 - 1))
    end
    cur_idx += count
  end

  (files.size - 1).downto(0) do |idx|
    id_number, file_range = files[idx]
    space_idx = free_space.index { |space_range| space_range.size >= file_range.size }

    next unless space_idx

    space = free_space[space_idx]
    first = space.begin
    last = space.end

    next if space.begin > file_range.begin

    files[idx] = {id_number, first..(first + file_range.size - 1)}

    new_space = (first + file_range.size)..last

    free_space[space_idx] = new_space

    free_space << file_range
    free_space.reject! { |range| range.size == 0 }
    free_space.sort_by!(&.begin)
  end

  sorted = (files + free_space.map { |range| {0_i64, range} }).sort_by(&.[1].begin)
  sorted.sum { |(n, range)| range.sum(&.*(n)) }
end

raise "Part 1 failed" unless get_filesystem_checksum("2333133121414131402") == 1928
raise "Part 2 failed" unless get_filesystem_checksum_with_new_method("2333133121414131402") == 2858

if ARGV.size > 0
  input = ARGV[0]
  puts get_filesystem_checksum(input)
  puts get_filesystem_checksum_with_new_method(input)
end
