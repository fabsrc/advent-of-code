# https://adventofcode.com/2025/day/11

# Part 1
def get_paths_count(input : String) : Int32
  devices = Hash(String, Set(String)).new { |hash, key| hash[key] = Set(String).new }

  input.each_line do |line|
    device, outputs = line.split(": ")
    outputs.split(" ").each do |output|
      devices[device] << output
    end
  end

  paths = [["you"]] of Array(String)

  count = 0

  until paths.empty?
    current = paths.shift
    next_devices = devices[current.last]? || [] of String
    next_devices.each do |next_device|
      count += 1 if next_device == "out"
      paths << current + [next_device]
    end
  end

  count
end

# Part 2
def get_svr_paths_count(input : String) : Int64
  devices = Hash(String, Set(String)).new { |hash, key| hash[key] = Set(String).new }

  input.each_line do |line|
    device, outputs = line.split(": ")
    outputs.split(" ").each do |output|
      devices[device] << output
    end
  end

  paths = Hash(Tuple(String, Bool, Bool), Int64).new(0_i64)
  paths[{"svr", false, false}] = 1_i64

  count = 0_i64

  until paths.empty?
    current_path, current_count = paths.shift
    current_device, has_fft, has_dac = current_path
    next_devices = devices[current_device]? || [] of String

    next_devices.each do |next_device|
      new_has_fft = has_fft || next_device == "fft"
      new_has_dac = has_dac || next_device == "dac"

      if next_device == "out" && new_has_fft && new_has_dac
        count += current_count
      else
        next_path = {next_device, new_has_fft, new_has_dac}
        paths[next_path] += current_count
      end
    end
  end

  count
end

test_input_1 = <<-INPUT
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
INPUT
test_input_2 = <<-INPUT
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
INPUT
raise "Part 1 failed" unless get_paths_count(test_input_1) == 5
raise "Part 2 failed" unless get_svr_paths_count(test_input_2) == 2

if ARGV.size > 0
  input = ARGV[0]
  puts get_paths_count(input)
  puts get_svr_paths_count(input)
end
