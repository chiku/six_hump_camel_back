require File.expand_path("../constraint", __FILE__)
require File.expand_path("../vector", __FILE__)

class Population
  def initialize(population, constraints, fitness_criteria)
    @population = population
    @constraints = constraints
    @degree = @constraints.size
    @fitness_criteria = fitness_criteria
    @vectors = @population.times.map { Vector.new(@constraints.map(&:random)) }
    @total_fitness = @vectors.reduce(0) { |acc, vector| acc + vector.fitness(@fitness_criteria) }
  end

  def [](index)
    @vectors[index]
  end

  def []=(index, vector)
    @vectors[index] = vector
  end

  def difference_vector(options)
    factor = options[:factor]
    r1     = options[:r1]
    r2     = options[:r2]
    r3     = options[:r3]

    base          = @vectors[r1]
    offset        = @vectors[r2] - @vectors[r3]
    scaled_offset = offset.scale_by(factor)

    base + scaled_offset
  end

  def crossover_vector(target, options)
    factor        = options[:factor]
    position      = options[:position]
    randomization = options[:randomization]

    target.crossover_with(@vectors[position], factor: factor, randomization: randomization)
  end

  def best_vector
    @vectors.min {|x, y| x.fitness(@fitness_criteria) <=> y.fitness(@fitness_criteria) }
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      vector = difference_vector(factor: 0.5, r1: rand(@population), r2: rand(@population), r3: rand(@population))
      target_vector = crossover_vector(vector, factor: 0.5, position: rand(@population), randomization: ->{ rand })
      trial_vector_position = rand(@population)
      if (target_vector.fitness(@fitness_criteria) < @vectors[trial_vector_position].fitness(@fitness_criteria))
        @total_fitness += (target_vector.fitness(@fitness_criteria) - @vectors[trial_vector_position].fitness(@fitness_criteria))
        @vectors[trial_vector_position] = target_vector
      end

      generations += 1
    end
    [@vectors[0], @vectors[0].fitness(@fitness_criteria), generations]
  end
  
  def convergance
    (@total_fitness/@population - best_vector.fitness(@fitness_criteria)).abs
  end
end
