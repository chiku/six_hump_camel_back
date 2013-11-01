require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :members

  # TODO : vector shouldn't know the constraints it was generated from
  # Constraints should be able to generate a vector member that lies within its range
  def initialize(constraints_or_members)
    if constraints_or_members.is_a?(Array) && constraints_or_members.first.is_a?(Constraint)
      constraints = constraints_or_members
      @degree  = constraints.size
      @members = constraints.map(&:random)
    else
      members = constraints_or_members
      @members = members
    end
  end

  def [](index)
    @members[index]
  end

  # TODO : don't mutate a vector after creation
  def []=(index, value)
    @members[index] = value
  end

  # TODO : device some caching of fitness. The cache should exist outside Vector
  def fitness(fitness_strategy)
    fitness_strategy.call(*@members)
  end

  def ==(other_value)
    @members == other_value.member
  end

  # TODO : remove compatibility method after usages are removed
  def member
    @members
  end
end
