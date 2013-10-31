class Constraint
  def initialize(options)
    @min        = options[:min]
    @max        = options[:max]
    @randomizer = -> { rand }
  end

  def range
    @max - @min
  end

  def randomizer=(randomizer)
    @randomizer = randomizer
  end

  def rand
    (@randomizer.call * range) + @min
  end
end
