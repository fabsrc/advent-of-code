class Group
  attr_reader :initiative, :type, :immunities, :weaknesses, :units
  attr_accessor :is_selected

  def initialize(type, units, hit_points, attack_damage, attack_type, initiative, weaknesses=[], immunities=[])
    @type = type
    @units = units
    @hit_points = hit_points
    @attack_damage = attack_damage
    @attack_type = attack_type
    @initiative = initiative
    @weaknesses = weaknesses || []
    @immunities = immunities || []
    @current_target = nil
    @is_selected = false
  end

  def effective_power
    @units * @attack_damage
  end

  def select_target(groups)
    targets = groups
      .reject{ |g|
        g.type == @type || g.is_selected || g.immunities.include?(@attack_type)
      }
      .sort_by{ |g|
        attack_damage = g.weaknesses.include?(@attack_type) ? 2 * effective_power : effective_power
        [-attack_damage, -g.effective_power, -g.initiative] 
      }
    
    unless targets.empty?
      @current_target = targets.first
      @current_target.is_selected = true
    end
  end

  def reset_target
    @current_target = nil
    @is_selected = false
  end

  def attack_target
    return unless @current_target
    attack_damage = @current_target.weaknesses.include?(@attack_type) ? 2 * effective_power : effective_power
    if attack_damage > 0
      @current_target.hit_with(attack_damage)
    end
  end

  def hit_with(attack_damage)
    @units -= (attack_damage / @hit_points)
  end

  def boost_by(boost)
    @attack_damage += boost
  end
end

def simulate_immune_system(input)
  initial_groups = input.scan(/Immune System:\n(.*)\n\nInfection:\n(.*)/m)
    .first
    .map{ |g| g.lines.map(&:chomp) }
    .flat_map.with_index{ |groups, i|
      groups.map{ |g| [g.match(/(?<units>\d+) units each with (?<hit_points>\d+) hit points (?:\((?<specials>.*)\))? ?with an attack that does (?<attack_damage>\d+) (?<attack_type>fire|slashing|bludgeoning|radiation|cold) damage at initiative (?<initiative>\d+)/), i] }
    }
    .map{ |g, i|
      if g[:specials]
        specials = g[:specials].split(";").map{ |s|
          [s.include?("weak") ? :weaknesses : :immunities, s.gsub(/weak to |immune to /, "").split(",").map(&:strip).map(&:to_sym)]
        }.to_h
      else
        specials = {}
      end
      Group.new(
        i,
        g[:units].to_i,
        g[:hit_points].to_i,
        g[:attack_damage].to_i,
        g[:attack_type].to_sym,
        g[:initiative].to_i,
        weaknesses=specials[:weaknesses],
        immunities=specials[:immunities]
      )
    }

  boost = 0
  loop do
    boost += 1
    groups = initial_groups.map(&:clone)
    groups.select{ |g| g.type == 0 }.map{ |g| g.boost_by(boost) }
    
    last_groups_units = nil

    while groups.any?{ |g| g.type == 1 } && groups.any?{ |g| g.type == 0 }
      groups.sort_by{ |g| [-g.effective_power, -g.initiative] }
        .each{ |g| g.select_target(groups) }
        .sort_by{ |g| -g.initiative }
        .each{ |g| g.attack_target }
        .each{ |g| g.reset_target }
      
      groups = groups.reject{ |g| g.units <= 0 }
      groups_units = groups.map(&:units)
      if last_groups_units == groups_units
        break
      end
      last_groups_units = groups_units
    end

    if groups.all?{ |g| g.type == 0 }
      return groups.sum(&:units)
    end
  end
end


fail unless simulate_immune_system("Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4") == 51
puts simulate_immune_system(ARGV[0]) if ARGV[0]
