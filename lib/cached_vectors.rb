class CachedVectors
  def initialize(*cached_vectors)
    @cached_vectors = *cached_vectors

    cache_entities
  end

  def [](index)
    @cached_vectors[index]
  end

  def []=(index, cached_vector)
    adjust_best_fitness(cached_vector)
    adjust_total_fitness(@cached_vectors[index], cached_vector)

    @cached_vectors[index] = cached_vector
  end

  def population_size
    @population_size
  end

  def best_vector
    @best_vector
  end

  def best_fitness
    @best_fitness
  end

  def total_fitness
    @total_fitness
  end

  def average_fitness
    total_fitness / population_size
  end

  def convergance
    (average_fitness - best_fitness).abs
  end

  def sample
    @cached_vectors.sample
  end

  private

  def cache_entities
    @population_size = @cached_vectors.size
    @best_vector     = @cached_vectors.min { |x, y| x.fitness <=> y.fitness }
    @best_fitness    = @best_vector.fitness
    @total_fitness   = @cached_vectors.map(&:fitness).reduce(0, &:+)
  end

  def adjust_best_fitness(replacement_vector)
    if replacement_vector.fitness < @best_vector.fitness
      @best_vector  = replacement_vector
      @best_fitness = replacement_vector.fitness
    end
  end

  def adjust_total_fitness(replaced_vector, replacement_vector)
    @total_fitness = @total_fitness - replaced_vector.fitness + replacement_vector.fitness
  end
end
