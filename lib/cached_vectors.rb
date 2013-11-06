class CachedVectors
  def initialize(*cached_vectors)
    @cached_vectors = *cached_vectors

    cache_entities
  end

  def [](index)
    @cached_vectors[index]
  end

  def []=(index, solved_vector)
    adjust_best_cost(solved_vector)
    adjust_total_cost(@cached_vectors[index], solved_vector)

    @cached_vectors[index] = solved_vector
  end

  def population_size
    @population_size
  end

  def best_vector
    @best_vector
  end

  def best_cost
    @best_cost
  end

  def total_cost
    @total_cost
  end

  def average_cost
    total_cost / population_size
  end

  def convergance
    (average_cost - best_cost).abs
  end

  def sample
    @cached_vectors.sample
  end

  private

  def cache_entities
    @population_size = @cached_vectors.size
    @best_vector     = @cached_vectors.min { |x, y| x.cost <=> y.cost }
    @best_cost       = @best_vector.cost
    @total_cost      = @cached_vectors.map(&:cost).reduce(0, &:+)
  end

  def adjust_best_cost(replacement_vector)
    if replacement_vector.cost < @best_vector.cost
      @best_vector  = replacement_vector
      @best_cost    = replacement_vector.cost
    end
  end

  def adjust_total_cost(replaced_vector, replacement_vector)
    @total_cost = @total_cost - replaced_vector.cost + replacement_vector.cost
  end
end
