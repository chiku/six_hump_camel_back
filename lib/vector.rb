require File.expand_path("../constraint", __FILE__)

class Vector
  attr_reader :degree, :fitness, :member

  def initialize(degree, min_constraints, max_constraints, fitness_strategy, randomize=true)
    @degree = degree
    @fitness_strategy = fitness_strategy

    @member = Array.new(@degree)
    @member.each_with_index do |each_value, index|
      constraints = Constraint.new(min: min_constraints[index], max: max_constraints[index])
      @member[index] = (randomize || range == 0) ? constraints.random : min_constraints[index].to_f
    end

    @fitness = randomize ? @fitness_strategy.call(*@member) : 0
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
