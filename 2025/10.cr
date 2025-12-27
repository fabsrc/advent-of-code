# https://adventofcode.com/2025/day/10

struct Machine
  property target : Int32
  property buttons : Array(Int32)
  property lights_count : Int32

  def initialize(pattern : String, button_lists : Array(Array(Int32)))
    @lights_count = pattern.size
    @target = pattern.each_char.with_index.reduce(0) do |acc, (c, i)|
      c == '#' ? (acc | (1 << i)) : acc
    end
    @buttons = button_lists.map { |indices| indices.reduce(0) { |m, idx| m | (1 << idx) } }
  end

  def min_presses : Int32
    max_states = 1 << @lights_count
    visited = Array(Bool).new(max_states, false)
    queue = [] of Tuple(Int32, Int32) # {state, presses}
    queue << {0, 0}
    visited[0] = true
    head = 0

    while head < queue.size
      state, presses = queue[head]
      head += 1
      return presses if state == @target

      @buttons.each do |b|
        ns = state ^ b
        unless visited[ns]
          visited[ns] = true
          queue << {ns, presses + 1}
        end
      end
    end

    Int32::MAX
  end
end

# Part 1
def get_fewest_button_presses(input : String) : Int32
  machines = input.lines.map do |line|
    parts = line.split
    lights = parts.first[1...(parts.first.size - 1)]
    buttons = parts[1...(parts.size - 1)].map { |b| b[1...(b.size - 1)].split(",").map(&.to_i) }
    Machine.new(lights, buttons)
  end

  machines.sum(&.min_presses)
end

class Counter < Array(Int32)
  # create from comma-separated string
  def self.from_string(s : String) : Counter
    c = Counter.new
    return c if s.empty?
    s.split(",").each { |x| c << x.to_i }
    c
  end

  def smaller_or_equal(other : Counter) : Bool
    size.times.all? { |i| self[i] <= other[i] }
  end

  def equals_modulo_2(other : Counter) : Bool
    size.times.all? { |i| (self[i] & 1) == (other[i] & 1) }
  end

  def zero? : Bool
    all?(&.zero?)
  end

  def subtract_div2(other : Counter) : Counter
    res = Counter.new(size, 0)
    size.times do |i|
      res[i] = (self[i] - other[i]) // 2
    end
    res
  end
end

struct Combination
  property counter : Counter
  property pressed : Int32

  def initialize(@counter, @pressed)
  end
end

struct Machine2
  property goal : Counter
  property buttons : Array(Counter)
  property counter : Counter

  def initialize(goal : Counter, buttons : Array(Counter), counter : Counter)
    @goal = goal
    @buttons = buttons
    @counter = counter
  end

  def combinations : Array(Combination)
    nb_buttons = @buttons.size
    m = @counter.size
    result = [] of Combination

    if nb_buttons == 0
      result << Combination.new(Counter.new(m, 0), 0)
      return result
    end

    (0...(1 << nb_buttons)).each do |mask|
      counter = Counter.new(m, 0)
      pressed = 0

      (0...nb_buttons).each do |j|
        if (mask & (1 << j)) != 0
          pressed += 1
          @buttons[j].each do |idx|
            counter[idx] += 1
          end
        end
      end

      result << Combination.new(counter, pressed)
    end

    result
  end

  def min_presses : Int32
    solve_rec(@counter, combinations, {} of String => Int32)
  end

  private def solve_rec(counter : Counter, combinations : Array(Combination), memo : Hash(String, Int32)) : Int32
    key = counter.join(",")
    return memo[key] if memo.has_key?(key)
    return 0 if counter.zero?

    best = Int32::MAX

    combinations.each do |comb|
      next unless comb.counter.smaller_or_equal(counter) && comb.counter.equals_modulo_2(counter)

      next_counter = counter.subtract_div2(comb.counter)

      rec = solve_rec(next_counter, combinations, memo)
      next if rec == -1

      value = 2 * rec + comb.pressed
      best = value if value < best
    end

    memo[key] = (best < Int32::MAX ? best : -1)
    memo[key]
  end
end

# Part 2
def get_fewest_button_presses_with_joltage(input : String) : Int32
  machines = input.lines.map do |line|
    fields = line.split

    goal = Counter.new
    (1...(fields[0].size - 1)).each do |i|
      goal << (fields[0][i] == '#' ? 1 : 0)
    end

    buttons = [] of Counter
    (1...(fields.size - 1)).each do |j|
      buttons << Counter.from_string(fields[j][1...(fields[j].size - 1)])
    end

    last = fields.last
    counter = Counter.from_string(last[1...(last.size - 1)])

    Machine2.new(goal, buttons, counter)
  end

  machines.sum(&.min_presses)
end

test_input = <<-INPUT
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
INPUT
raise "Part 1 failed" unless get_fewest_button_presses(test_input) == 7
raise "Part 2 failed" unless get_fewest_button_presses_with_joltage(test_input) == 33

if ARGV.size > 0
  input = ARGV[0]
  puts get_fewest_button_presses(input)
  puts get_fewest_button_presses_with_joltage(input)
end
