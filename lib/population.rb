require File.expand_path("../constraint", __FILE__)
require File.expand_path("../vector", __FILE__)

class Population
  def initialize(vectors, fitness_criteria)
    @vectors          = vectors
    @population       = vectors.size
    @fitness_criteria = fitness_criteria
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
    @vectors.min {|x, y| x.fitness(@fitness_criteria) <=> y.fitness(@fitness_criteria) }
  end

  # TODO : device caching of fitness.
  def total_fitness
    @vectors.reduce(0) { |acc, vector| acc + vector.fitness(@fitness_criteria) }
  end

  def convergance
    (total_fitness/@population - best_vector.fitness(@fitness_criteria)).abs
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      vector = difference_vector(factor: 0.5, v1: random_vector, v2: random_vector, v3: random_vector)
      target_vector = crossover_vector(target: vector, factor: 0.5, partner: random_vector, randomization: ->{ rand })
      trial_vector_position = rand(@population)
      if (target_vector.fitness(@fitness_criteria) < self[trial_vector_position].fitness(@fitness_criteria))
        self[trial_vector_position] = target_vector
      end

      generations += 1
    end
    [self[0], self[0].fitness(@fitness_criteria), generations]
  end

  def random_vector
    @vectors.sample
  end
end
