require 'forwardable'

class CacheCreator
  def initialize(fitness_criteria)
    @fitness_criteria = fitness_criteria
  end

  def cache(vector)
    CachedVector.new(vector, vector.fitness(@fitness_criteria), self)
  end
end

class CachedVector < Struct.new(:vector, :fitness, :cacher)
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
