require File.expand_path("../constraint", __FILE__)
require File.expand_path("../vector", __FILE__)

class Population
  attr_reader :population

  def initialize(population, degree, min_constraints, max_constraints, fitness_criteria, difference_factor=0.5, crossingover_factor=0.5)
    @population = population
    @degree = degree
    @constraints = min_constraints.zip(max_constraints).map { |min, max| Constraint.new(min: min, max: max) }
    @max_constraints = max_constraints
    @min_constraints = min_constraints
    @fitness_criteria = fitness_criteria
    @difference_factor = difference_factor
    @crossingover_factor = crossingover_factor
    @vectors = @population.times.map { Vector.new(@constraints, @fitness_criteria) }
    @total_fitness = @vectors.reduce(0) { |acc, vector| acc + vector.fitness }
  end

  def [](index)
    @vectors[index]
  end

  def difference_vector
    r1 = rand(@population)
    r2 = rand(@population)
    r3 = rand(@population)

    values = Array.new(@degree)
    0.upto(@degree-1) do |index|
      base_vector = best_vector #@vectors[r1][index] 
      values[index] = base_vector[index] + @difference_factor * (self[r2][index] - self[r3][index])
    end
    
    constraints = values.map { |value| Constraint.new(min: value, max: value) }
    Vector.new(constraints, @fitness_criteria)
  end

  def best_vector
    @vectors.min {|x, y| x.fitness <=> y.fitness }
  end

  def crossover_vector
    vector = difference_vector

    values = Array.new(@degree)
    0.upto(@degree-1) do |index|
      values[index] = rand() < @crossingover_factor ? vector[index] : self[rand(@population)][index]
    end

    constraints = values.map { |value| Constraint.new(min: value, max: value) }
    Vector.new(constraints, @fitness_criteria)
  end

  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations += 1) < max_generations && precision < (@total_fitness/@population - best_vector.fitness).abs) do
      target_vector = crossover_vector
      trial_vector_position = rand(@population)
      if (target_vector.fitness < @vectors[trial_vector_position].fitness)
        @total_fitness += (target_vector.fitness - @vectors[trial_vector_position].fitness)
        @vectors[trial_vector_position] = target_vector
      end
    end
    return [@vectors[0], @vectors[0].fitness, generations]
  end
end
