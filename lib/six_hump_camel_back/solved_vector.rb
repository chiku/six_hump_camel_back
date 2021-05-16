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

  SolvedVector =
    Struct.new(:vector, :cost, :cacher) do
      extend Forwardable

      delegated_methods_for_one_vector = [:scale_by].freeze
      delegated_methods_for_two_vectors = %i[- + crossover_with].freeze

      delegated_methods_for_one_vector.each do |method|
        define_method(method) do |*args, &block|
          cached { vector.public_send(method, *args, &block) }
        end
      end

      delegated_methods_for_two_vectors.each do |method|
        define_method(method) do |other, *args, &block|
          cached { vector.public_send(method, other.vector, *args, &block) }
        end
      end

      def ==(other)
        (vector == other) || (other.respond_to?(:vector) && vector == other.vector)
      end

      def hash
        @hash ||= vector.hash
      end

      private def cached
        cacher.cache(yield)
      end
    end

  public_constant :SolvedVector
end
