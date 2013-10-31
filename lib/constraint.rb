class Constraint
  def initialize(options)
    @min = options[:min]
    @max = options[:max]
  end

  def range
    @max - @min
  end
end
