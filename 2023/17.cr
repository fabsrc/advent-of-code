# https://adventofcode.com/2023/day/17

struct Position
  enum Direction
    Up
    Right
    Down
    Left
  end

  def initialize(@x : Int32, @y : Int32, @dir : Direction)
  end

  def coords
    {@x, @y}
  end

  def step_forward(&)
    yield case @dir
    in Direction::Up
      Position.new(@x, @y - 1, Direction::Up)
    in Direction::Right
      Position.new(@x + 1, @y, Direction::Right)
    in Direction::Down
      Position.new(@x, @y + 1, Direction::Down)
    in Direction::Left
      Position.new(@x - 1, @y, Direction::Left)
    end
  end

  def step_left(&)
    yield case @dir
    in Direction::Up
      Position.new(@x - 1, @y, Direction::Left)
    in Direction::Right
      Position.new(@x, @y - 1, Direction::Up)
    in Direction::Down
      Position.new(@x + 1, @y, Direction::Right)
    in Direction::Left
      Position.new(@x, @y + 1, Direction::Down)
    end
  end

  def step_right(&)
    yield case @dir
    in Direction::Up
      Position.new(@x + 1, @y, Direction::Right)
    in Direction::Right
      Position.new(@x, @y + 1, Direction::Down)
    in Direction::Down
      Position.new(@x - 1, @y, Direction::Left)
    in Direction::Left
      Position.new(@x, @y - 1, Direction::Up)
    end
  end
end

class PriorityQueue(T)
  def initialize(@elements : Array(T))
  end

  def push(element : T)
    @elements << element
    heapify_up(@elements.size - 1)
  end

  def pop : T
    return @elements.pop if @elements.size == 1

    swap(0, @elements.size - 1)
    result = @elements.pop
    heapify_down(0)
    result
  end

  private def heapify_up(index)
    while index > 0
      parent_index = (index - 1) // 2

      if @elements[index].first < @elements[parent_index].first
        swap(index, parent_index)
        index = parent_index
      else
        break
      end
    end
  end

  private def heapify_down(index)
    loop do
      left_child_index = 2 * index + 1
      right_child_index = 2 * index + 2
      smallest = index

      if left_child_index < @elements.size && @elements[left_child_index].first < @elements[smallest].first
        smallest = left_child_index
      end

      if right_child_index < @elements.size && @elements[right_child_index].first < @elements[smallest].first
        smallest = right_child_index
      end

      if smallest != index
        swap(index, smallest)
        index = smallest
      else
        break
      end
    end
  end

  private def swap(i, j)
    @elements[i], @elements[j] = @elements[j], @elements[i]
  end

  forward_missing_to @elements
end

# Part 1: min_steps = 0, max_steps = 3
# Part 2: min_steps = 4, max_steps = 10
def get_path_with_least_heat_loss(map_input : String, min_steps : Int32, max_steps : Int32) : Int32
  map = Hash(Tuple(Int32, Int32), Int32).new

  map_input.lines.each_with_index do |line, y|
    line.each_char_with_index do |c, x|
      map[{x, y}] = c.to_i
    end
  end

  target_coords = {map_input.lines[0].size - 1, map_input.lines.size - 1}

  queue = PriorityQueue.new([
    {0, Position.new(0, 0, Position::Direction::Down), 0},
    {0, Position.new(0, 0, Position::Direction::Right), 0},
  ])
  visited = Set(Tuple(Position, Int32)).new

  until queue.empty?
    next_item = queue.pop

    heat_loss, pos, step_count = next_item

    return heat_loss if pos.coords == target_coords && step_count >= min_steps

    next if visited.includes?({pos, step_count})

    visited << {pos, step_count}

    pos.step_left do |next_pos|
      if map.has_key?(next_pos.coords) && step_count >= min_steps
        queue.push({heat_loss + map[next_pos.coords], next_pos, 1})
      end
    end

    pos.step_right do |next_pos|
      if map.has_key?(next_pos.coords) && step_count >= min_steps
        queue.push({heat_loss + map[next_pos.coords], next_pos, 1})
      end
    end

    pos.step_forward do |next_pos|
      if map.has_key?(next_pos.coords) && step_count < max_steps
        queue.push({heat_loss + map[next_pos.coords], next_pos, step_count + 1})
      end
    end
  end

  0
end

test_input_1 = <<-INPUT
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
INPUT

test_input_2 = <<-INPUT
111111111111
999999999991
999999999991
999999999991
999999999991
INPUT

raise "Part 1 failed" unless get_path_with_least_heat_loss(test_input_1, 0, 3) == 102
raise "Part 2 failed" unless get_path_with_least_heat_loss(test_input_1, 4, 10) == 94
raise "Part 2 failed" unless get_path_with_least_heat_loss(test_input_2, 4, 10) == 71

if ARGV.size > 0
  input = ARGV[0]
  puts get_path_with_least_heat_loss(input, 0, 3)
  puts get_path_with_least_heat_loss(input, 4, 10)
end
