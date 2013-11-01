require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "when rand() returns 0.5" do
    let(:vector) { Vector.new([1, 0]) }

    describe "members" do
      describe "after initialize" do
        it "lie midway between the constraints" do
          vector[0].must_equal 1
          vector[1].must_equal 0
        end
      end
    end
  
    describe "#fitness" do
      let(:add_two) { ->(i, j) { i + j } }
      let(:fitness) { vector.fitness(add_two) }

      it "is the value of the fitness strategy solved with member values" do
        fitness.must_equal 1.0
      end
    end

    describe "#==" do
      it "doesn't equal another vector with different members" do
        vector.wont_equal Vector.new([2, 0])
      end

      it "equals a vector with same members" do
        vector.must_equal Vector.new([1, 0])
      end
    end
  end
end
