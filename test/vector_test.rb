require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/population", __FILE__)

describe "Vector" do
  describe "when rand() returns 0.5" do
    let(:vector) { Vector.new([1, 0]) }
    let(:another_vector) { Vector.new([0, 1]) }

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
        (vector == Vector.new([2, 0])).must_equal false
        (vector != Vector.new([2, 0])).must_equal true
      end

      it "equals a vector with same members" do
        (vector == Vector.new([1, 0])).must_equal true
        (vector != Vector.new([1, 0])).must_equal false
      end

      it "doesn't equal an array" do
        (vector == [1, 0]).must_equal false
        (vector != [1, 0]).must_equal true
      end
    end

    describe "#-" do
      it "is the difference of individual elements" do
        (vector - another_vector).must_equal Vector.new([1, -1])
      end
    end

    describe "#+" do
      it "is the sum of individual elements" do
        (vector + another_vector).must_equal Vector.new([1, 1])
      end
    end

    describe "#scale_by" do
      it "is the product of the members by the scalar number" do
        vector.scale_by(2).must_equal Vector.new([2, 0])
      end
    end
  end
end
