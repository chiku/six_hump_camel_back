class CacheCreator
  def initialize(fitness_criteria)
    @fitness_criteria = fitness_criteria
  end

  def cache(vector)
    CachedVector.new(vector, vector.fitness(@fitness_criteria), self)
  end
end

class CachedVector
  attr_reader :vector, :fitness

  def initialize(vector, fitness, cacher)
    @vector = vector
    @fitness = fitness
    @cacher = cacher
  end

  def fitness
    @fitness
  end

  def ==(other_value)
    (vector == other_value) || (other_value.respond_to?(:vector) && vector == other_value.vector)
  end

  def hash
    vector.hash
  end

  def -(other)
    cache { vector - other.vector }
  end

  def +(other)
    cache { vector + other.vector }
  end

  def scale_by(number)
    cache { vector.scale_by(number) }
  end

  def crossover_with(other, options)
    cache { vector.crossover_with(other.vector, options) }
  end

  private

  def cache(&block)
    @cacher.cache(yield)
  end
end
