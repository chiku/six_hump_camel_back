# frozen_string_literal: true

module SixHumpCamelBack
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

    def ==(other)
      other.respond_to?(:members) && @members == other.members
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

    private def pair_with(other)
      @members.zip(other.members)
    end

    private def crossover?(chance, threshold)
      chance > threshold
    end
  end
end
