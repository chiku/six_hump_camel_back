# frozen_string_literal: true

require_relative '../test_helper'

require_relative '../../lib/six_hump_camel_back'

describe 'SixHumpCamelBack::Population' do
  let(:add_two) { ->(i, j) { i + j } }
  let(:cacher) { SixHumpCamelBack::CacheCreator.new(add_two) }
  let(:population) do
    SixHumpCamelBack::Population.new(
      [
        SixHumpCamelBack::Vector.new(1, 0),
        SixHumpCamelBack::Vector.new(3, -1),
        SixHumpCamelBack::Vector.new(1, 2)
      ],
      add_two
    )
  end

  describe '#difference_vector' do
    it 'is a vector around the target separated by a difference between second and third vectors' do
      value(
        population.difference_vector(
          factor: 0.5,
          v1: population[0],
          v2: population[1],
          v3: population[2]
        )
      ).must_equal(cacher.cache(SixHumpCamelBack::Vector.new(2, -1.5)))
    end
  end

  describe '#crossover_vector' do
    let(:cycle) { [0.2, 0.8].cycle }
    let(:randomization) { -> { cycle.next } }

    it 'is a vector chosen from a target vector and another vector based on crossover factor' do
      value(
        population.crossover_vector(
          target: population[0],
          factor: 0.5,
          partner: population[1],
          randomization: randomization
        )
      ).must_equal(cacher.cache(SixHumpCamelBack::Vector.new(3, 0)))
    end
  end

  describe 'with cost criteria x squared plus one' do
    it 'has a minima at zero' do
      constraints = [SixHumpCamelBack::Constraint.new(min: -100, max: 100)]
      vectors = 100.times.map { SixHumpCamelBack::Vector.new(constraints.map(&:random)) }
      population = SixHumpCamelBack::Population.new(vectors, ->(x) { (x * x) + 1 })
      vector, value, _generations, _convergance = population.differential_evolution(200_000, 0.00005)

      assert_in_delta(value, 1.0, 0.0005)
      assert_in_delta(vector[0], 0.0, 0.008)
    end
  end

  describe 'for camel hump back problem' do
    it 'has a solution' do
      constraints = [SixHumpCamelBack::Constraint.new(min: -3.0, max: 3.0), SixHumpCamelBack::Constraint.new(min: -2.0, max: 2.0)]
      vectors = 100.times.map { SixHumpCamelBack::Vector.new(constraints.map(&:random)) }
      population = SixHumpCamelBack::Population.new(
        vectors,
        lambda { |x, y|
          ((4.0 - (x * 2.1 * x) + (x * x * x * x / 3.0)) * x * x) + (x * y) + (((y * 4.0 * y) + -4.0) * y * y)
        }
      )
      vector, value, _generations, _convergance = population.differential_evolution(200_000, 0.00005)

      assert_in_delta(value, - 1.0316, 0.0005)
      assert_in_delta(vector[0].abs, 0.0898, 0.0005)
      assert_in_delta(vector[1].abs, 0.7126, 0.0005)
    end
  end
end
