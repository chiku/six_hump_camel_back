require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :degree, :fitness, :member

  def initialize(degree, constraints, fitness_strategy, randomize=true)
    @degree = constraints.size
    @fitness_strategy = fitness_strategy

    if randomize
      @member = constraints.map(&:random)
      @fitness = @fitness_strategy.call(*@member)
    else
      @member = constraints.map(&:min)
      @fitness = 0
    end
  end

  def [](index)
    @member[index]
  end

  def []=(index, value)
    if (@member[index] == value)
      return
    end
    @member[index] = value
    @fitness = @fitness_strategy.call(*@member)
  end

  def ==(other_value)
    if (@degree != other_value.degree)
      false
    end
    (@member == other_value.member)
  end
end
