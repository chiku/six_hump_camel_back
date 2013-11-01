require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "when rand() returns 0.5" do
    let(:constrain_0_to_2) { Constraint.new(min: 0, max: 2).with_constant_randomization(0.5) }
    let(:constrain_minus1_to_1) { Constraint.new(min: -1, max: 1).with_constant_randomization(0.5) }
    let(:constrains) { [constrain_0_to_2, constrain_minus1_to_1] }
    let(:add_two) { ->(i, j) { i + j } }
    let(:vector) { Vector.new(constrains, add_two) }

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

    describe "with three member" do
      it "has a fitness" do
        constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
        vector = Vector.new(constraints, lambda {|i, j, k| i - j * k})
        assert_equal(1, vector.fitness)
      end
    end

    it "doesn't equal another vector with different degree" do
      constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2)]
      vector = Vector.new(constraints, lambda {|i, j| i + j})
      other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
      other_vector = Vector.new(other_constraints, lambda {|i, j, k| i + j})
      assert(vector != other_vector)
    end
  
    it "equals a vector with same members" do
      constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
      vector = Vector.new(constraints, lambda {|i, j, k| i - j * k})
      other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
      other_vector = Vector.new(constraints, lambda {|i, j, k| i + j * k})
      assert_equal(vector, other_vector)
    end

    it "doesn't equal a vector with one different member" do
      constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
      vector = Vector.new(constraints, lambda {|i, j, k| i - j * k})
      other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 0, max: 0)]
      other_vector = Vector.new(other_constraints, lambda {|i, j, k| i - j * k})
      assert(vector != other_vector)
    end
  end
end
