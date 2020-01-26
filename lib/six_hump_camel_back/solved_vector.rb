# frozen_string_literal: true

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

  SolvedVector = Struct.new(:vector, :cost, :cacher) do
    extend Forwardable

    DELEGATED_METHODS_FOR_ONE_VECTOR = [:scale_by].freeze
    DELEGATED_METHODS_FOR_TWO_VECTORS = %i[- + crossover_with].freeze

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

    def ==(other)
      (vector == other) || (other.respond_to?(:vector) && vector == other.vector)
    end

    def hash
      @hash ||= vector.hash
    end

    private

    def cached
      cacher.cache(yield)
    end
  end
end
