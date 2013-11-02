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
    other_value.respond_to?(:members) && @members == other_value.members
  end

  def -(other)
    Vector.new(@members.zip(other.members).map { |x, y| x - y })
  end

  def +(other)
    Vector.new(@members.zip(other.members).map { |x, y| x + y })
  end

  def scale_by(number)
    Vector.new(@members.map { |x| x * number })
  end

  def crossover_with(other, options)
    crossover_factor = options[:factor]
    randomization    = options[:randomization]
    Vector.new(@members.zip(other.members).map { |x, y| randomization.call < crossover_factor ? x : y })
  end
end
