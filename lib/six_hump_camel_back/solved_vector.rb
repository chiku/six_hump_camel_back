require 'forwardable'

module SixHumpCamelBack
  class CacheCreator
    def initialize(cost_criteria)
      @cost_criteria = cost_criteria
    end

    def cache(vector)
      SolvedVector.new(vector, vector.cost(@cost_criteria), self)
    end
  end

  class SolvedVector < Struct.new(:vector, :cost, :cacher)
    extend Forwardable

    DELEGATED_METHODS_FOR_ONE_VECTOR = [:scale_by]
    DELEGATED_METHODS_FOR_TWO_VECTORS = [:-, :+, :crossover_with]

    DELEGATED_METHODS_FOR_ONE_VECTOR.each do |method|
      define_method(method) do |*args, &block|
        cached { vector.send(method, *args, &block) }
      end
    end

    DELEGATED_METHODS_FOR_TWO_VECTORS.each do |method|
      define_method(method) do |other, *args, &block|
        cached { vector.send(method, other.vector, *args, &block) }
      end
    end

    def ==(other_value)
      (vector == other_value) || (other_value.respond_to?(:vector) && vector == other_value.vector)
    end

    def hash
      @hash ||= vector.hash
    end

    private

    def cached(&block)
      cacher.cache(yield)
    end
  end
end