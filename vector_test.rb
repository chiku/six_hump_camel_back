require "test/unit"
require "./vector"

class VectorTest < Test::Unit::TestCase

  def test_members_in_vector_created_lie_between_constraints
    10.times do
      vector = Vector.new(5, [0, 2.2, 3, 5, -1], [2, 4.5, 5, 6, 0], lambda {|i, j, k, l, m| i + j})
      assert(vector[0] >= 0 && vector[0] <= 2)
      assert(vector[1] >= 2.2 && vector[1] <= 4.5)
      assert(vector[2] >= 3 && vector[2] <= 5)
      assert(vector[3] >= 5 && vector[3] <= 6)
      assert(vector[4] >= -1 && vector[4] <= 0)
    end
  end

  def test_members_in_a_vector_generate_the_same_value_when_constraints_are_equal
    10.times do
      vector = Vector.new(2, [0, 2.2], [0, 2.2], lambda {|i, j| i + j})
      assert_equal(0, vector[0])
      assert_equal(2.2, vector[1])
    end
  end
  
  def test_vector_members_can_be_properly_set
    vector = Vector.new(2, [0, 2.2], [1, 2.2], lambda {|i, j| i + j})
    vector[0] = 100
    assert_equal(100, vector[0])
  end

  def test_fitness_of_a_vector_is_properly_evaluated
    vector = Vector.new(2, [1, 3.2], [1, 3.2], lambda {|i, j| i + j})
    assert_equal(4.2, vector.fitness)
  end

  def test_fitness_of_a_vector_is_changed_when_one_member_changes
    vector = Vector.new(2, [1, 3.2], [1, 3.2], lambda {|i, j|  (i - j)})
    vector[0] = -3.2
    assert_equal(-6.4, vector.fitness)
  end

  def test_fitness_of_a_vector_with_three_members_is_proper
    vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
    assert_equal(1, vector.fitness)
  end

  def test_two_vectors_with_different_degree_are_not_equal
    vector = Vector.new(2, [33, 3.2], [33, 3.2], lambda {|i, j| i + j})
    other_vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i + j})
    assert_not_equal(vector, other_vector)
  end
  

  def test_two_vectors_with_same_members_are_equal
    vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
    other_vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i + j * k})
    assert_equal(vector, other_vector)
  end


  def test_two_vectors_with_one_different_members_are_equal
    vector = Vector.new(3, [33, 3.2, 10], [33, 3.2, 10], lambda {|i, j, k| i - j * k})
        assert_equal(1, vector.fitness)
    other_vector = Vector.new(3, [33, 3.2, 0], [33, 3.2, 0], lambda {|i, j, k| i - j * k})
    assert_not_equal(vector, other_vector)
  end
end

