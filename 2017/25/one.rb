def turing(input)
  meta, *states = input.split("\n\n").map { |i| i.split("\n").reject(&:empty?) }
  start = /([A-Z])\.$/.match(meta[0])[1]
  steps = /(\d+)\ssteps\.$/.match(meta[1])[1].to_i

  states = states.inject({}) do |all_states, values|
    values.map! { |v| /([A-Z0-9]|right|left)[.:]$/.match(v)[1] }
    all_states[values[0]] = {
      0 => values[2..4],
      1 => values[6..8]
    }
    all_states
  end

  tape = {}
  cursor = 0
  state = states[start]

  steps.times do
    value = tape[cursor] || 0
    new_value, direction, new_state = state[value]
    new_value = new_value.to_i
    tape[cursor] = new_value
    cursor += direction == 'right' ? 1 : -1
    state = states[new_state]
  end

  tape.each_value.sum
end

puts(turing(%(Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.)) == 3)

puts(turing(%(Begin in state A.
Perform a diagnostic checksum after 12861455 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state C.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state E.

In state C:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state E.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state D.

In state D:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.

In state E:
  If the current value is 0:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state A.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state F.

In state F:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state E.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.)))
