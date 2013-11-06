require "forwardable"

require File.expand_path("../constraint", __FILE__)
require File.expand_path("../cached_vector", __FILE__)
require File.expand_path("../cached_vectors", __FILE__)

class Population
  extend Forwardable

  DELEGATED_METHODS = [:[], :[]=, :best_vector, :best_fitness, :average_fitness, :convergance]

  DELEGATED_METHODS.each do |method|
    def_delegator :@vectors, method, method
  end

  def initialize(vectors, fitness_criteria)
    @cacher     = CacheCreator.new(fitness_criteria)
    @vectors    = CachedVectors.new(*vectors.map { |vector| @cacher.cache(vector) })
    @population = vectors.size
  end

  def difference_vector(options)
    factor = options[:factor]
    v1     = options[:v1]
    v2     = options[:v2]
    v3     = options[:v3]

    v1 + (v2 - v3).scale_by(factor)
  end

  def crossover_vector(options)
    target        = options[:target]
    factor        = options[:factor]
    partner       = options[:partner]
    randomization = options[:randomization]

    target.crossover_with(partner, factor: factor, randomization: randomization)
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      vector = difference_vector(factor: 0.5, v1: random_vector, v2: random_vector, v3: random_vector)
      target_vector = crossover_vector(target: vector, factor: 0.5, partner: random_vector, randomization: ->{ rand })
      trial_vector_position = rand(@population)
      if (target_vector.fitness < @vectors[trial_vector_position].fitness)
        @vectors[trial_vector_position] = target_vector
      end

      generations += 1
    end

    [best_vector.vector, best_fitness, generations, convergance]
  end

  private

  def random_vector
    @vectors.sample
  end
end
