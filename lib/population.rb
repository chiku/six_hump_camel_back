require File.expand_path("../constraint", __FILE__)
require File.expand_path("../cached_vector", __FILE__)

class Population
  def initialize(vectors, fitness_criteria)
    @cacher           = CacheCreator.new(fitness_criteria)
    @vectors          = vectors.map { |vector| @cacher.cache(vector) }
    @population       = vectors.size
  end

  def [](index)
    @vectors[index]
  end

  def []=(index, vector)
    @vectors[index] = vector
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

  def best_vector
    @vectors.min { |x, y| x.fitness <=> y.fitness }
  end

  def best_fitness
    fitnesses.min
  end

  def average_fitness
    fitnesses.reduce(0, &:+) / @population
  end

  def convergance
    (average_fitness - best_fitness).abs
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      vector = difference_vector(factor: 0.5, v1: random_vector, v2: random_vector, v3: random_vector)
      target_vector = crossover_vector(target: vector, factor: 0.5, partner: random_vector, randomization: ->{ rand })
      trial_vector_position = rand(@population)
      if (target_vector.fitness < self[trial_vector_position].fitness)
        self[trial_vector_position] = target_vector
      end

      generations += 1
    end
    [best_vector.vector, best_fitness, generations, convergance]
  end

  private

  def fitnesses
    @vectors.map(&:fitness)
  end

  def random_vector
    @vectors.sample
  end
end
