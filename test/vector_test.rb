require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "members" do
    it "lie between constraints" do
      10.times do
        constraints = [Constraint.new(min: 0, max: 2), Constraint.new(min: 2.2, max: 4.5), Constraint.new(min: 3, max: 5), Constraint.new(min: 5, max: 6), Constraint.new(min: -1, max: 0)]
        vector = Vector.new(5, constraints, lambda {|i, j, k, l, m| i + j})
        assert(vector[0] >= 0 && vector[0] <= 2)
        assert(vector[1] >= 2.2 && vector[1] <= 4.5)
        assert(vector[2] >= 3 && vector[2] <= 5)
        assert(vector[3] >= 5 && vector[3] <= 6)
        assert(vector[4] >= -1 && vector[4] <= 0)
      end
    end

    describe "when constraints are equal" do
      it "generate the same value" do
        10.times do
          constraints = [Constraint.new(min: 0, max: 0), Constraint.new(min: 2.2, max: 2.2)]
          vector = Vector.new(2, constraints, lambda {|i, j| i + j})
          assert_equal(0, vector[0])
          assert_equal(2.2, vector[1])
        end
      end
    end
  
    it "can be set" do
      constraints = [Constraint.new(min: 0, max: 1), Constraint.new(min: 2.2, max: 2.2)]
      vector = Vector.new(2, constraints, lambda {|i, j| i + j})
      vector[0] = 100
      assert_equal(100, vector[0])
    end
  end

  it "has a fitness" do
    constraints = [Constraint.new(min: 1, max: 1), Constraint.new(min: 3.2, max: 3.2)]
    vector = Vector.new(2, constraints, lambda {|i, j| i + j})
    assert_equal(4.2, vector.fitness)
  end

  describe "fitness" do
    it "differs when one member changes" do
      constraints = [Constraint.new(min: 1, max: 1), Constraint.new(min: 3.2, max: 3.2)]
      vector = Vector.new(2, constraints, lambda {|i, j|  (i - j)})
      vector[0] = -3.2
      assert_equal(-6.4, vector.fitness)
    end
  end

  describe "with three member" do
    it "has a fitness" do
      constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
      vector = Vector.new(3, constraints, lambda {|i, j, k| i - j * k})
      assert_equal(1, vector.fitness)
    end
  end

  it "doesn't equal another vector with different degree" do
    constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2)]
    vector = Vector.new(2, constraints, lambda {|i, j| i + j})
    other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
    other_vector = Vector.new(3, other_constraints, lambda {|i, j, k| i + j})
    assert(vector != other_vector)
  end
  
  it "equals a vector with same members" do
    constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
    vector = Vector.new(3, constraints, lambda {|i, j, k| i - j * k})
    other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
    other_vector = Vector.new(3, constraints, lambda {|i, j, k| i + j * k})
    assert_equal(vector, other_vector)
  end

  it "doesn't equal a vector with one different member" do
    constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 10, max: 10)]
    vector = Vector.new(3, constraints, lambda {|i, j, k| i - j * k})
    other_constraints = [Constraint.new(min: 33, max: 33), Constraint.new(min: 3.2, max: 3.2), Constraint.new(min: 0, max: 0)]
    other_vector = Vector.new(3, other_constraints, lambda {|i, j, k| i - j * k})
    assert(vector != other_vector)
  end
end
