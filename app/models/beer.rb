class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

	def average_rating

		avg = 0;

		self.ratings.each do |rating|
			avg += rating.score
		end

		avg = avg / self.ratings.count
		"Has #{self.ratings.count}" + " rating".pluralize(self.ratings.count) + ", average #{avg}"

	end
end
