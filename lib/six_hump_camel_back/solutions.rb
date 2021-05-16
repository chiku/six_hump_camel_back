# frozen_string_literal: true

module SixHumpCamelBack
  class Solutions
    def initialize(*solutions)
      @solutions = *solutions

      cache_entities
    end

    def [](index)
      @solutions[index]
    end

    def []=(index, solved_vector)
      adjust_best_cost(solved_vector)
      adjust_total_cost(@solutions[index], solved_vector)

      @solutions[index] = solved_vector
    end

    attr_reader :population_size, :best_vector, :best_cost, :total_cost

    def average_cost
      total_cost / population_size
    end

    def convergance
      (average_cost - best_cost).abs
    end

    def sample
      @solutions.sample
    end

    private def cache_entities
      @population_size = @solutions.size
      @best_vector     = @solutions.min { |x, y| x.cost <=> y.cost }
      @best_cost       = @best_vector.cost
      @total_cost      = @solutions.map(&:cost).reduce(0, &:+)
    end

    private def adjust_best_cost(replacement_vector)
      return unless replacement_vector.cost < @best_vector.cost

      @best_vector = replacement_vector
      @best_cost   = replacement_vector.cost
    end

    private def adjust_total_cost(replaced_vector, replacement_vector)
      @total_cost = @total_cost - replaced_vector.cost + replacement_vector.cost
    end
  end
end
