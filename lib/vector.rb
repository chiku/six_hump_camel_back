require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :members

  def initialize(*members)
    @members = members.flatten
  end

  def [](index)
    @members[index]
  end

  def cost(cost_strategy)
    cost_strategy.call(*@members)
  end

  def ==(other_value)
    other_value.respond_to?(:members) && @members == other_value.members
  end

  def hash
    @members.hash
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
