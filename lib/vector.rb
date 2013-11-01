require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :members

  def initialize(members)
    @members = members
  end

  def [](index)
    @members[index]
  end

  # TODO : device some caching of fitness. The cache should exist outside Vector
  def fitness(fitness_strategy)
    fitness_strategy.call(*@members)
  end

  def ==(other_value)
    @members == other_value.members
  end
end
