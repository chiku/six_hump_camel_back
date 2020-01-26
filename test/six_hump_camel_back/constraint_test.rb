require_relative "../test_helper"

require_relative "../../lib/six_hump_camel_back/constraint"

describe "SixHumpCamelBack::Constraint" do
  describe "when rand() returns 0.5" do
    let(:constraint) { SixHumpCamelBack::Constraint.new(max: 2.0, min: -1.0).with_constant_randomization(0.5) }

    describe "#range" do
      it "is the difference between the maximun and minimum" do
        value(constraint.range).must_equal 3.0
      end
    end

    describe "#random" do
      let(:random) { constraint.random }

      it "is less than the maximum value" do
        value(random).must_be :<=, 2.0
      end

      it "is more than the minimum value" do
        value(random).must_be :>=, -1.0
      end

      it "is midway between the maximum and minimum values" do
        value(random).must_equal 0.5
      end
    end
  end
end
