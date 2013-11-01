require File.expand_path("../constraint", __FILE__)
require File.expand_path("../vector", __FILE__)

class Population
  def initialize(population, constraints, fitness_criteria)
    @population = population
    @constraints = constraints
    @degree = @constraints.size
    @fitness_criteria = fitness_criteria
    @vectors = @population.times.map { Vector.new(@constraints, @fitness_criteria) }
    @total_fitness = @vectors.reduce(0) { |acc, vector| acc + vector.fitness }
  end

  def [](index)
    @vectors[index]
  end

  def difference_vector(difference_factor=0.5)
    r1 = rand(@population)
    r2 = rand(@population)
    r3 = rand(@population)

    values = Array.new(@degree)
    0.upto(@degree-1) do |index| # TODO : simplify
      base_vector = @vectors[r1]
      values[index] = base_vector[index] + difference_factor * (self[r2][index] - self[r3][index])
    end
    
    constraints = values.map { |value| Constraint.new(min: value, max: value) }
    Vector.new(constraints, @fitness_criteria)
  end

  def best_vector
    @vectors.min {|x, y| x.fitness <=> y.fitness }
  end

  def crossover_vector(crossingover_factor=0.5)
    vector = difference_vector

    values = Array.new(@degree)
    0.upto(@degree-1) do |index| # TODO : simplify
      values[index] = rand() < crossingover_factor ? vector[index] : self[rand(@population)][index]
    end

    constraints = values.map { |value| Constraint.new(min: value, max: value) }
    Vector.new(constraints, @fitness_criteria)
  end

  # TODO : move into a separate class - DifferentialEvolution
  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      target_vector = crossover_vector
      trial_vector_position = rand(@population)
      if (target_vector.fitness < @vectors[trial_vector_position].fitness)
        @total_fitness += (target_vector.fitness - @vectors[trial_vector_position].fitness)
        @vectors[trial_vector_position] = target_vector
      end

      generations += 1
    end
    [@vectors[0], @vectors[0].fitness, generations]
  end
  
  def convergance
    (@total_fitness/@population - best_vector.fitness).abs
  end
end
