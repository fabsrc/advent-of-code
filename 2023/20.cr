# https://adventofcode.com/2023/day/20

class Module
  enum Type
    Unknown
    FlipFlop
    Conjunction
    Broadcast
    Button
  end

  getter name, destination_names, counts, origin_pulses

  def initialize(@name : String, @type : Type, @destination_names = Array(String).new)
    @state = false
    @destinations = [] of Module
    @origin_pulses = Hash(String, Symbol).new { :low }
    @counts = {:low => 0.to_i64, :high => 0.to_i64}
  end

  def connect_destination(destination_module : Module)
    @destinations << destination_module

    destination_module.set_origin_pulses(self)
  end

  protected def set_origin_pulses(origin_module : Module)
    @origin_pulses[origin_module.name] = :low
  end

  def generate_pulses(pulse : Symbol, origin : Module) : Array(Tuple(Module, Module, Symbol))
    @counts[pulse] += 1

    pulses_to_send = [] of Tuple(Module, Module, Symbol)

    case @type
    when Type::Broadcast
      pulses_to_send = @destinations.map do |dest|
        {self, dest, pulse}
      end
    when Type::FlipFlop
      if pulse == :low
        next_pulse = @state ? :low : :high
        @state = @state ? false : true

        pulses_to_send = @destinations.map do |dest|
          {self, dest, next_pulse}
        end
      end
    when Type::Conjunction
      @origin_pulses[origin.name] = pulse

      pulses_to_send = @destinations.map do |dest|
        {self, dest, @origin_pulses.values.all?(:high) ? :low : :high}
      end
    end

    pulses_to_send
  end
end

# Part 1
def get_product_of_total_low_and_high_pulse_counts(module_config_input : String) : Int32
  modules = Hash(String, Module).new

  module_config_input.lines.each do |line|
    match, *_ = line.scan(/([%&]?)(\w+) -> ([\w,\s]+)/)
    _, type, name, destinations = match
    destinations = destinations.split(", ")

    destinations.map do |dest|
      modules[dest] ||= Module.new(dest, Module::Type::Unknown)
    end

    case type
    when "%"
      modules[name] = Module.new(name, Module::Type::FlipFlop, destinations)
    when "&"
      modules[name] = Module.new(name, Module::Type::Conjunction, destinations)
    else
      modules[name] = Module.new(name, Module::Type::Broadcast, destinations)
    end
  end

  button = Module.new("button", Module::Type::Button, ["broadcaster"])

  modules.values.each do |mod|
    mod.destination_names.each do |dest_name|
      mod.connect_destination(modules[dest_name])
    end
  end

  1000.times do
    queue = modules["broadcaster"].generate_pulses(:low, button)
    until queue.empty?
      origin_mod, dest_mod, pulse = queue.shift
      queue.concat(dest_mod.generate_pulses(pulse, origin_mod))
    end
  end

  modules.values.reduce({0, 0}) { |counts, mod|
    {counts[0] + mod.counts[:low], counts[1] + mod.counts[:high]}
  }.product
end

# Part 2
def get_fewest_number_of_button_presses_for_rx(module_config_input : String) : Int64
  modules = Hash(String, Module).new

  module_config_input.each_line do |line|
    match, *_ = line.scan(/([%&]?)(\w+) -> ([\w,\s]+)/)
    _, type, name, destinations = match
    destinations = destinations.split(", ")

    destinations.each do |dest|
      modules[dest] ||= Module.new(dest, Module::Type::Unknown, [] of String)
    end

    case type
    when "%"
      modules[name] = Module.new(name, Module::Type::FlipFlop, destinations)
    when "&"
      modules[name] = Module.new(name, Module::Type::Conjunction, destinations)
    else
      modules[name] = Module.new(name, Module::Type::Broadcast, destinations)
    end
  end

  button = Module.new("button", Module::Type::Button, ["broadcaster"])

  modules.values.each do |mod|
    mod.destination_names.each do |dest_name|
      mod.connect_destination(modules[dest_name])
    end
  end

  button_presses = 0.to_i64
  rx_origin_pulses = modules[modules["rx"].origin_pulses.keys.first].origin_pulses
  cycles_presses = Hash(String, Int64).new

  loop do
    button_presses += 1

    queue = modules["broadcaster"].generate_pulses(:low, button)
    until queue.empty?
      origin_mod, dest_mod, pulse = queue.shift

      queue.concat(dest_mod.generate_pulses(pulse, origin_mod))

      high = rx_origin_pulses.find { |k, v| v == :high }

      cycles_presses[high[0]] ||= button_presses if high
    end

    break if cycles_presses.size == rx_origin_pulses.size
  end

  cycles_presses.values.reduce { |a, b| a.lcm(b) }
end

test_input_1 = <<-INPUT
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
INPUT

test_input_2 = <<-INPUT
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
INPUT

raise "Part 1 failed" unless get_product_of_total_low_and_high_pulse_counts(test_input_1) == 32000000
raise "Part 1 failed" unless get_product_of_total_low_and_high_pulse_counts(test_input_2) == 11687500

if ARGV.size > 0
  input = ARGV[0]
  puts get_product_of_total_low_and_high_pulse_counts(input)
  puts get_fewest_number_of_button_presses_for_rx(input)
end
