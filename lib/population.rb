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

  def difference_vector(difference_factor=0.5)
    r1 = rand(@population)
    r2 = rand(@population)
    r3 = rand(@population)

    base_vector = @vectors[r1]
    base_vector + (self[r2] - self[r3]).scale_by(difference_factor)
  end

  def best_vector
    @vectors.min {|x, y| x.fitness(@fitness_criteria) <=> y.fitness(@fitness_criteria) }
  end

  # TODO : move relevant parts of this method into Vector
  def crossover_vector(crossingover_factor=0.5)
    vector = difference_vector

    values = Array.new(@degree)
    0.upto(@degree-1) do |index| # TODO : simplify
      values[index] = rand() < crossingover_factor ? vector[index] : self[rand(@population)][index]
    end

    Vector.new(values)
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      target_vector = crossover_vector
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
