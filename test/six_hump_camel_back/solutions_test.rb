# frozen_string_literal: true

require_relative '../test_helper'

require_relative '../../lib/six_hump_camel_back'

describe 'SixHumpCamelBack::CachedVectors' do
  let(:add_two) { ->(i, j) { i + j } }
  let(:cacher) { SixHumpCamelBack::CacheCreator.new(add_two) }
  let(:population) do
    SixHumpCamelBack::Population.new([
                                       SixHumpCamelBack::Vector.new(1.0, 0.0),
                                       SixHumpCamelBack::Vector.new(3.0, -1.0),
                                       SixHumpCamelBack::Vector.new(1.0, 2.0)
                                     ], add_two)
  end
  let(:solutions) do
    SixHumpCamelBack::Solutions.new(
      cacher.cache(SixHumpCamelBack::Vector.new(1.0, 0.0)),
      cacher.cache(SixHumpCamelBack::Vector.new(3.0, -1.0)),
      cacher.cache(SixHumpCamelBack::Vector.new(1.0, 2.0))
    )
  end

  describe '#[]' do
    it 'is a solved vector at the given position' do
      value(solutions[0]).must_equal cacher.cache(SixHumpCamelBack::Vector.new(1.0, 0.0))
    end
  end

  describe '#[]=' do
    let(:new_vector) { cacher.cache(SixHumpCamelBack::Vector.new(2.0, 3.0)) }
    before { solutions[0] = new_vector }

    it 'sets a vector at the given position' do
      value(solutions[0]).must_equal new_vector
    end
  end

  describe '#best_vector' do
    it 'is the vector with minimum value for cost function in the population' do
      value(solutions.best_vector).must_equal population[0]
    end

    describe 'when a new vector replaces a member of the collectcion' do
      describe 'when the new vector is fitter than the existing best vector' do
        let(:fitter_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 0.0)) }
        before { solutions[2] = fitter_vector }

        it 'is updated' do
          value(solutions.best_vector).must_equal fitter_vector
        end
      end
    end

    describe 'when a new vector replaces a member of the collectcion' do
      describe 'when the new vector is not fitter than the existing best vector' do
        let(:new_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 1.0)) }
        before { solutions[2] = new_vector }

        it 'is not updated' do
          value(solutions.best_vector).must_equal population[0]
        end
      end
    end
  end

  describe '#best_cost' do
    it 'is the minimum value for cost function in the population' do
      value(solutions.best_cost).must_equal 1.0
    end

    describe 'when a new vector replaces a member of the collectcion' do
      describe 'when the new vector is not fitter than the existing best vector' do
        let(:fitter_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 0.0)) }
        before { solutions[2] = fitter_vector }

        it 'is updated' do
          value(solutions.best_cost).must_equal 0.0
        end
      end
    end

    describe 'when a new vector replaces a member of the collectcion' do
      describe 'when the new vector is not fitter than the existing best vector' do
        let(:new_vector) { cacher.cache(SixHumpCamelBack::Vector.new(1.0, 1.0)) }
        before { solutions[2] = new_vector }

        it 'is not updated' do
          value(solutions.best_cost).must_equal 1.0
        end
      end
    end
  end

  describe '#total_cost' do
    it 'is the sum of all costes in the collection' do
      value(solutions.total_cost).must_equal 6.0
    end

    describe 'when a new vector replaces a member of the collectcion' do
      let(:new_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 0.0)) }
      before { solutions[2] = new_vector }

      it 'is updated' do
        value(solutions.total_cost).must_equal 3.0
      end
    end
  end

  describe '#average_cost' do
    it 'is the average of all costes in the population' do
      value(solutions.average_cost).must_equal 2.0
    end

    describe 'when a new vector replaces a member of the collectcion' do
      let(:new_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 0.0)) }
      before { solutions[2] = new_vector }

      it 'is updated' do
        value(solutions.average_cost).must_equal 1.0
      end
    end
  end

  describe '#convergance' do
    it 'is the difference of average cost and best cost' do
      value(solutions.convergance).must_equal 1.0
    end

    describe 'when a new vector replaces a member of the collectcion' do
      describe 'when the new vector is fitter than the existing best vector' do
        let(:fitter_vector) { cacher.cache(SixHumpCamelBack::Vector.new(0.0, 0.0)) }
        before { solutions[2] = fitter_vector }

        it 'is updated' do
          value(solutions.convergance).must_equal 1.0
        end
      end
    end
  end
end
