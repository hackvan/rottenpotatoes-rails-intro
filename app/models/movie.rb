class Movie < ActiveRecord::Base
  def self.all_ratings
    self.select('rating').group(:rating).map { |r| r.rating }
  end
end
