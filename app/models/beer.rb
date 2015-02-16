class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	validates :name, presence: true
	validates :name, length: { minimum: 1 }

	validates :style_id, presence: true

	def to_s
		"#{self.brewery.name}: #{self.name}"
	end
end
