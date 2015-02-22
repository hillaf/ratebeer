class Brewery < ActiveRecord::Base
	include RatingAverage
	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

	validates :name, length: { minimum: 1 }

	validates :year, numericality: { greater_than_or_equal_to: 1024,
																	 less_than_or_equal_to: ->(_){Time.now.year},
																	 only_integer: true }

	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false] }

	def print_report
		puts name
		puts "established at year #{year}"
		puts "number of beers #{beers.count}"
	end

	def to_s
		"#{self.name}"
	end

	def restart
		self.year = 2015
		puts "changed year to #{year}"
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
		return sorted_by_rating_in_desc_order[0, n]
	end

end
