require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/constraint", __FILE__)

describe "Constraint" do
  describe "#range" do
    it "is the difference between the maximun and minimum" do
      Constraint.new(max: 2.4, min: -1.1).range.must_equal 3.5
    end
  end
end
