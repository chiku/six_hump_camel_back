require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "members" do
    it "lie between constraints" do
      10.times do
        vector = Vector.new(5, [0, 2.2, 3, 5, -1], [2, 4.5, 5, 6, 0], lambda {|i, j, k, l, m| i + j})
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
          vector = Vector.new(2, [0, 2.2], [0, 2.2], lambda {|i, j| i + j})
          assert_equal(0, vector[0])
          assert_equal(2.2, vector[1])
        end
      end
    end
  
    it "are setable" do
      vector = Vector.new(2, [0, 2.2], [1, 2.2], lambda {|i, j| i + j})
      vector[0] = 100
      assert_equal(100, vector[0])
    end
  end

  it "has a fitness" do
    vector = Vector.new(2, [1, 3.2], [1, 3.2], lambda {|i, j| i + j})
    assert_equal(4.2, vector.fitness)
  end

  describe "fitness" do
    it "differs when one member changes" do
      vector = Vector.new(2, [1, 3.2], [1, 3.2], lambda {|i, j|  (i - j)})
      vector[0] = -3.2
      assert_equal(-6.4, vector.fitness)
    end
  end

  describe "with three member" do
    it "has a fitness" do
      vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
      assert_equal(1, vector.fitness)
    end
  end

  it "doesn't equal another vector with different degree" do
    vector = Vector.new(2, [33, 3.2], [33, 3.2], lambda {|i, j| i + j})
    other_vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i + j})
    assert(vector != other_vector)
  end
  
  it "equals a vector with same members" do
    vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
    other_vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i + j * k})
    assert_equal(vector, other_vector)
  end

  it "doesn't equal a vector with one different member" do
    vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
        assert_equal(1, vector.fitness)
    other_vector = Vector.new(3, [33, 3.2, 0], [33, 3.2, 0], lambda {|i, j, k| i - j * k})
    assert(vector != other_vector)
  end
end
