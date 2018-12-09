class Marble
  attr_reader :value

  def initialize(value, next_marble = self, previous_marble = self)
    @value = value
    @next = next_marble
    @previous = previous_marble
    @previous.next = self
    @next.previous = self
  end

  def previous(n = 1)
    n == 1 ? @previous : @previous.previous(n - 1)
  end

  def next(n = 1)
    n == 1 ? @next : @next.next(n - 1)
  end

  def remove
    @previous.next = @next
    @next.previous = @previous
  end
  
  protected 
  attr_writer :previous, :next
end

def winning_score(input)
  players, last_marble_value = input.scan(/\d+/).map(&:to_i)
  score = Array.new(players, 0)
  current_marble = Marble.new(0)

  1.upto (last_marble_value * 100) do |marble_value|
    if marble_value.modulo(23).zero?
      current_player = marble_value % players
      marble_to_remove = current_marble.previous(7)
      score[current_player] += marble_value + marble_to_remove.value
      marble_to_remove.remove
      current_marble = marble_to_remove.next
    else
      current_marble = Marble.new(marble_value, current_marble.next(2), current_marble.next)
    end
  end

  score.max
end

p winning_score(ARGV[0]) if ARGV[0]
