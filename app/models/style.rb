class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers

  def to_s
    "#{self.name}"
  end



end
