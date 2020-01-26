# frozen_string_literal: true

require_relative '../test_helper'

require_relative '../../lib/six_hump_camel_back/vector'

describe 'SixHumpCamelBack::Vector' do
  describe 'when rand() returns 0.5' do
    let(:vector) { SixHumpCamelBack::Vector.new(1, 0) }
    let(:another_vector) { SixHumpCamelBack::Vector.new(0, 1) }

    describe 'members' do
      describe 'after initialize' do
        it 'lie midway between the constraints' do
          value(vector[0]).must_equal 1
          value(vector[1]).must_equal 0
        end
      end
    end

    describe '#cost' do
      let(:add_two) { ->(i, j) { i + j } }
      let(:cost) { vector.cost(add_two) }

      it 'is the value of the cost strategy solved with member values' do
        value(cost).must_equal 1.0
      end
    end

    describe '#==' do
      it 'does not equal another vector with different members' do
        value(vector == SixHumpCamelBack::Vector.new(2, 0)).must_equal false
        value(vector != SixHumpCamelBack::Vector.new(2, 0)).must_equal true
      end

      it 'equals a vector with same members' do
        value(vector == SixHumpCamelBack::Vector.new(1, 0)).must_equal true
        value(vector != SixHumpCamelBack::Vector.new(1, 0)).must_equal false
      end

      it 'does not equal an array' do
        value(vector == [1, 0]).must_equal false
        value(vector != [1, 0]).must_equal true
      end
    end

    describe '#hash' do
      it 'equals another vector with same members' do
        value(vector.hash).must_equal SixHumpCamelBack::Vector.new(1, 0).hash
      end
    end

    describe '#-' do
      it 'is the difference of individual elements' do
        value(vector - another_vector).must_equal SixHumpCamelBack::Vector.new(1, -1)
      end
    end

    describe '#+' do
      it 'is the sum of individual elements' do
        value(vector + another_vector).must_equal SixHumpCamelBack::Vector.new(1, 1)
      end
    end

    describe '#scale_by' do
      it 'is the product of the members by the scalar number' do
        value(vector.scale_by(2)).must_equal SixHumpCamelBack::Vector.new(2, 0)
      end
    end

    describe '#crossover_with' do
      let(:cycle) { [0.2, 0.8].cycle }
      let(:randomization) { -> { cycle.next } }

      it 'is composed of elements from itself and other vector selected by randomization' do
        value(vector.crossover_with(another_vector, randomization: randomization, factor: 0.5)).must_equal SixHumpCamelBack::Vector.new(0, 0)
      end

      it 'is the original vector when crossover-factor is 0' do
        value(vector.crossover_with(another_vector, randomization: randomization, factor: 0)).must_equal vector
      end

      it 'is the partner vector when crossover-factor is 1' do
        value(vector.crossover_with(another_vector, randomization: randomization, factor: 1)).must_equal another_vector
      end
    end
  end
end
