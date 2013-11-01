require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/constraint", __FILE__)

describe "Constraint" do
  let(:constraint) { Constraint.new(max: 2.0, min: -1.0) }

  describe "#min" do
    it "is the lower bound" do
      constraint.min.must_equal -1.0
    end
  end

  describe "#max" do
    it "is the upper bound" do
      constraint.max.must_equal 2.0
    end
  end

  describe "#range" do
    it "is the difference between the maximun and minimum" do
      constraint.range.must_equal 3.0
    end
  end

  describe "#random" do
    let(:random) { constraint.random }

    describe "when rand() return 0.0" do
      before { constraint.randomizer = -> { 0.5 } }

      it "is less than the maximum value" do
        random.must_be :<=, 2.0
      end

      it "is more than the minimum value" do
        random.must_be :>=, -1.0
      end

      it "is midway between the maximum and minimum values" do
        random.must_equal 0.5
      end
    end
  end
end
