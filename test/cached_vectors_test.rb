require File.expand_path("../test_helper", __FILE__)

require File.expand_path("../../lib/constraint", __FILE__)
require File.expand_path("../../lib/vector", __FILE__)
require File.expand_path("../../lib/cached_vectors", __FILE__)
require File.expand_path("../../lib/population", __FILE__)

describe "CachedVectors" do
  let(:add_two) { ->(i, j) { i + j } }
  let(:cacher) { CacheCreator.new(add_two) }
  let(:population) { Population.new([Vector.new(1.0, 0.0), Vector.new(3.0, -1.0), Vector.new(1.0, 2.0)], add_two) }
  let(:cached_vectors) { CachedVectors.new(cacher.cache(Vector.new(1.0, 0.0)), cacher.cache(Vector.new(3.0, -1.0)), cacher.cache(Vector.new(1.0, 2.0))) }

  describe "#[]" do
    it "is a solved vector at the given position" do
      cached_vectors[0].must_equal cacher.cache(Vector.new(1.0, 0.0))
    end
  end

  describe "#[]=" do
    let(:new_vector) { cacher.cache(Vector.new(2.0, 3.0)) }
    before { cached_vectors[0] = new_vector }

    it "sets a vector at the given position" do
      cached_vectors[0].must_equal new_vector
    end
  end

  describe "#best_vector" do
    it "is the vector with minimum value for cost function in the population" do
      cached_vectors.best_vector.must_equal population[0]
    end

    describe "when a new vector replaces a member of the collectcion" do
      describe "when the new vector is fitter than the existing best vector" do
        let(:fitter_vector) { cacher.cache(Vector.new(0.0, 0.0)) }
        before { cached_vectors[2] = fitter_vector }

        it "is updated" do
          cached_vectors.best_vector.must_equal fitter_vector
        end
      end
    end

    describe "when a new vector replaces a member of the collectcion" do
      describe "when the new vector is not fitter than the existing best vector" do
        let(:new_vector) { cacher.cache(Vector.new(0.0, 1.0)) }
        before { cached_vectors[2] = new_vector }

        it "is not updated" do
          cached_vectors.best_vector.must_equal population[0]
        end
      end
    end
  end

  describe "#best_cost" do
    it "is the minimum value for cost function in the population" do
      cached_vectors.best_cost.must_equal 1.0
    end

    describe "when a new vector replaces a member of the collectcion" do
      describe "when the new vector is not fitter than the existing best vector" do
        let(:fitter_vector) { cacher.cache(Vector.new(0.0, 0.0)) }
        before { cached_vectors[2] = fitter_vector }

        it "is updated" do
          cached_vectors.best_cost.must_equal 0.0
        end
      end
    end

    describe "when a new vector replaces a member of the collectcion" do
      describe "when the new vector is not fitter than the existing best vector" do
        let(:new_vector) { cacher.cache(Vector.new(1.0, 1.0)) }
        before { cached_vectors[2] = new_vector }

        it "is not updated" do
          cached_vectors.best_cost.must_equal 1.0
        end
      end
    end
  end

  describe "#total_cost" do
    it "is the sum of all costes in the collection" do
      cached_vectors.total_cost.must_equal 6.0
    end

    describe "when a new vector replaces a member of the collectcion" do
      let(:new_vector) { cacher.cache(Vector.new(0.0, 0.0)) }
      before { cached_vectors[2] = new_vector }

      it "is updated" do
        cached_vectors.total_cost.must_equal 3.0
      end
    end
  end

  describe "#average_cost" do
    it "is the average of all costes in the population" do
      cached_vectors.average_cost.must_equal 2.0
    end

    describe "when a new vector replaces a member of the collectcion" do
      let(:new_vector) { cacher.cache(Vector.new(0.0, 0.0)) }
      before { cached_vectors[2] = new_vector }

      it "is updated" do
        cached_vectors.average_cost.must_equal 1.0
      end
    end
  end

  describe "#convergance" do
    it "is the difference of average cost and best cost" do
      cached_vectors.convergance.must_equal 1.0
    end

    describe "when a new vector replaces a member of the collectcion" do
      describe "when the new vector is fitter than the existing best vector" do
        let(:fitter_vector) { cacher.cache(Vector.new(0.0, 0.0)) }
        before { cached_vectors[2] = fitter_vector }

        it "is updated" do
          cached_vectors.convergance.must_equal 1.0
        end
      end
    end
  end
end
