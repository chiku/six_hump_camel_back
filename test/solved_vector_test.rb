require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/vector", __FILE__)
require File.expand_path("../../lib/solved_vector", __FILE__)

describe "CachedVector" do
  let(:vector) { Vector.new(1, 2) }
  let(:add_two) { ->(x, y) { x + y } }
  let(:creator) { CacheCreator.new(add_two) }
  let(:solved_vector) { creator.cache(vector) }

  let(:vector_with_same_members) { Vector.new(1, 2) }
  let(:vector_with_other_members) { Vector.new(1, -2) }
  let(:solution_with_same_members) { creator.cache(vector_with_same_members) }
  let(:solution_with_other_members) { creator.cache(vector_with_other_members) }

  describe "#==" do
    describe "when comparing to another solved vector" do
      it "is equal if they have same members" do
        (solved_vector == solution_with_same_members).must_equal true
      end

      it "is not equal if they have different members" do
        (solved_vector == solution_with_other_members).must_equal false
      end
    end

    describe "when comparing to another cached vector" do
      it "is equal if they have same members" do
        (solved_vector == vector_with_same_members).must_equal true
      end

      it "isn't equal if they have different members" do
        (solved_vector == vector_with_other_members).must_equal false
      end
    end

    describe "when comparing to an array" do
      it "isn't equal" do
        (solved_vector == [1, 2]).must_equal false
      end
    end
  end

  describe "#hash" do
    it "is same for same cached vector" do
      solved_vector.hash.must_equal solution_with_same_members.hash
    end
  end

  describe "#scale_by" do
    it "is delegated to the underlying vector" do
      solved_vector.scale_by(2).must_equal creator.cache(Vector.new(2, 4))
    end
  end

  describe "#-" do
    it "subtracts the underlying vectors" do
      (solved_vector - solved_vector).must_equal creator.cache(Vector.new(0, 0))
    end
  end

  describe "#+" do
    it "adds the underlying vectors" do
      (solved_vector + solved_vector).must_equal creator.cache(Vector.new(2, 4))
    end
  end

  describe "#scale_by" do
    it "multiplies the underlying vector with a scalar" do
      solved_vector.scale_by(0.5).must_equal creator.cache(Vector.new(0.5, 1))
    end
  end

  describe "#crossover_with" do
    it "cross-over the underlying vectors" do
      solved_vector.crossover_with(solution_with_other_members, factor: 0.5, randomization: -> { 0.9 }).must_equal solved_vector
    end
  end
end
