require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :member

  # TODO : vector shouldn't know the constraints it was generated from
  # Constraints should be able to generate a vector member that lies within its range
  def initialize(constraints)
    @degree           = constraints.size
    @member           = constraints.map(&:random)

    expire_fitness_cache
  end

  def [](index)
    @member[index]
  end

  def []=(index, value)
    expire_fitness_cache
    @member[index] = value
  end

  def fitness(fitness_strategy)
    @fitness ||= fitness_strategy.call(*@member)
  end

  def ==(other_value)
    @member == other_value.member
  end

  def expire_fitness_cache
    @fitness = nil
  end
end
