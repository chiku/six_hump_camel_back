require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :degree, :member

  def initialize(constraints, fitness_strategy)
    @degree           = constraints.size
    @fitness_strategy = fitness_strategy
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

  def fitness
    @fitness ||= @fitness_strategy.call(*@member)
  end

  def ==(other_value)
    @member == other_value.member
  end

  def expire_fitness_cache
    @fitness = nil
  end
end
