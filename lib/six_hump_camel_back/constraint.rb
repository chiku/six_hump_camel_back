# frozen_string_literal: true

module SixHumpCamelBack
  class Constraint
    def initialize(options)
      @min        = options[:min]
      @max        = options[:max]
      @randomizer = -> { rand }
    end

    def range
      @max - @min
    end

    def random
      (@randomizer.call * range) + @min
    end

    def with_constant_randomization(value)
      @randomizer = -> { value }
      self
    end
  end
end
