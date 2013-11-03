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
    Vector.new(pair_with(other).map { |x, y| x - y })
  end

  def +(other)
    Vector.new(pair_with(other).map { |x, y| x + y })
  end

  def scale_by(number)
    Vector.new(@members.map { |x| x * number })
  end

  def crossover_with(other, options)
    factor        = options[:factor]
    randomization = options[:randomization]
    Vector.new(pair_with(other).map { |x, y| crossover?(randomization.call, factor) ? x : y })
  end

  private

  def pair_with(other)
    @members.zip(other.members)
  end

  def crossover?(chance, threshold)
    chance > threshold
  end
end
