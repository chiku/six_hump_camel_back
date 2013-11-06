require "forwardable"

require File.expand_path("../constraint", __FILE__)
require File.expand_path("../solved_vector", __FILE__)
require File.expand_path("../cached_vectors", __FILE__)

class Population
  extend Forwardable

  DELEGATED_METHODS = [:[], :[]=, :best_vector, :best_cost, :average_cost, :convergance]

  DELEGATED_METHODS.each do |method|
    def_delegator :@vectors, method, method
  end

  def initialize(vectors, cost_criteria)
    @cacher          = CacheCreator.new(cost_criteria)
    @vectors         = CachedVectors.new(*vectors.map { |vector| @cacher.cache(vector) })
    @population_size = vectors.size
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

  def differential_evolution(max_generations, precision)
    generations = 0

    while ((generations < max_generations) && (precision < convergance)) do
      replace_member_with_lower_cost_target
      generations += 1
    end

    [best_vector.vector, best_cost, generations, convergance]
  end

  private

  def replace_member_with_lower_cost_target
    vector                = difference_vector(factor: 0.5, v1: random_vector, v2: random_vector, v3: random_vector)
    target_vector         = crossover_vector(target: vector, factor: 0.5, partner: random_vector, randomization: ->{ rand })
    trial_vector_position = rand(@population_size)

    if (target_vector.cost < @vectors[trial_vector_position].cost)
      @vectors[trial_vector_position] = target_vector
    end
  end

  def random_vector
    @vectors.sample
  end
end
