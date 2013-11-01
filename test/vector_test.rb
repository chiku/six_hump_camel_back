require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "when rand() returns 0.5" do
    let(:constraint_0_to_2) { Constraint.new(min: 0, max: 2).with_constant_randomization(0.5) }
    let(:constraint_minus1_to_1) { Constraint.new(min: -1, max: 1).with_constant_randomization(0.5) }
    let(:constraints) { [constraint_0_to_2, constraint_minus1_to_1] }
    let(:add_two) { ->(i, j) { i + j } }
    let(:vector) { Vector.new(constraints, add_two) }

    describe "members" do
      describe "after initialize" do
        it "lie midway between the constraints" do
          vector[0].must_equal 1
          vector[1].must_equal 0
        end
      end

      it "can be set" do
        vector[0] = 100
        vector[0].must_equal 100
      end
    end
  
    describe "#fitness" do
      let(:fitness) { vector.fitness }

      it "is the value of the fitness strategy solved with member values" do
        fitness.must_equal 1.0
      end

      describe "when one member changes" do
        it "is revaluated" do
          vector[1] = -3.2
          fitness.must_equal -2.2
        end
      end

      describe "when member value is reset to older value" do
        it "is remains the same" do
          vector[1] = 0
          fitness.must_equal 1.0
        end
      end
    end

    describe "#==" do
      it "doesn't equal another vector with different members" do
        other_vector = Vector.new(constraints, add_two)
        other_vector[0] = vector[0] + 1
        vector.wont_equal other_vector
      end

      it "equals a vector with same members" do
        other_vector = Vector.new(constraints, add_two)
        vector.must_equal other_vector
      end
    end
  end
end
