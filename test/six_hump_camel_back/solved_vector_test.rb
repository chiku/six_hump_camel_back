require_relative "../test_helper"

require_relative "../../lib/six_hump_camel_back"

describe "SixHumpCamelBack::SolvedVector" do
  let(:vector) { SixHumpCamelBack::Vector.new(1, 2) }
  let(:add_two) { ->(x, y) { x + y } }
  let(:creator) { SixHumpCamelBack::CacheCreator.new(add_two) }
  let(:solved_vector) { creator.cache(vector) }

  let(:vector_with_same_members) { SixHumpCamelBack::Vector.new(1, 2) }
  let(:vector_with_other_members) { SixHumpCamelBack::Vector.new(1, -2) }
  let(:solution_with_same_members) { creator.cache(vector_with_same_members) }
  let(:solution_with_other_members) { creator.cache(vector_with_other_members) }

  describe "#==" do
    describe "when comparing to another solved vector" do
      it "is equal if they have same members" do
        value(solved_vector == solution_with_same_members).must_equal true
      end

      it "is not equal if they have different members" do
        value(solved_vector == solution_with_other_members).must_equal false
      end
    end

    describe "when comparing to another cached vector" do
      it "is equal if they have same members" do
        value(solved_vector == vector_with_same_members).must_equal true
      end

      it "isn't equal if they have different members" do
        value(solved_vector == vector_with_other_members).must_equal false
      end
    end

    describe "when comparing to an array" do
      it "isn't equal" do
        value(solved_vector == [1, 2]).must_equal false
      end
    end
  end

  describe "#hash" do
    it "is same for same cached vector" do
      value(solved_vector.hash).must_equal solution_with_same_members.hash
    end
  end

  describe "#scale_by" do
    it "is delegated to the underlying vector" do
      value(solved_vector.scale_by(2)).must_equal creator.cache(SixHumpCamelBack::Vector.new(2, 4))
    end
  end

  describe "#-" do
    it "subtracts the underlying vectors" do
      value(solved_vector - solved_vector).must_equal creator.cache(SixHumpCamelBack::Vector.new(0, 0))
    end
  end

  describe "#+" do
    it "adds the underlying vectors" do
      value(solved_vector + solved_vector).must_equal creator.cache(SixHumpCamelBack::Vector.new(2, 4))
    end
  end

  describe "#scale_by" do
    it "multiplies the underlying vector with a scalar" do
      value(solved_vector.scale_by(0.5)).must_equal creator.cache(SixHumpCamelBack::Vector.new(0.5, 1))
    end
  end

  describe "#crossover_with" do
    it "cross-over the underlying vectors" do
      value(solved_vector.crossover_with(solution_with_other_members, factor: 0.5, randomization: -> { 0.9 })).must_equal solved_vector
    end
  end
end
