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
    it "is a value between inside the range" do
      constraint.randomizer = -> { 0.5 }
      constraint.random.must_equal 0.5
    end
  end
end
