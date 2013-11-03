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

  DELEGATED_METHODS = [:-, :+, :crossover_with]

  DELEGATED_METHODS.each do |method|
    define_method(method) do |other, *args|
      as_cache { vector.send(method, *[other.vector, *args]) }
    end
  end

  def ==(other_value)
    (vector == other_value) || (other_value.respond_to?(:vector) && vector == other_value.vector)
  end

  def hash
    vector.hash
  end

  def scale_by(number)
    as_cache { vector.scale_by(number) }
  end

  private

  def as_cache(&block)
    cacher.cache(yield)
  end
end
