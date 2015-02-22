class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :ratings, dependent: :destroy

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                       maximum: 15 }

  validates :password, length: { minimum: 4 }

  validates :password, format: { with: /\d.*[A-Z]|[A-Z].*\d/, message: "has to contain one number and one upper case letter" }


  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |b| b.ratings.count}.reverse
    return sorted_by_rating_in_desc_order[0, n]
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    return nil if ratings.empty?
    brewery_ratings = rated_breweries.inject([]) do |ratings, brewery|
      ratings << {
          name: brewery,
          rating: rating_of_brewery(brewery) }
    end
    brewery_ratings.sort_by { |brewery| brewery[:rating] }.reverse.first[:name]
  end

  def favorite_style
    return nil if ratings.empty?
    style_ratings = rated_styles.inject([]) do |ratings, style|
      ratings << {
          name: style,
          rating: rating_of_style(style) }
    end
    style_ratings.sort_by { |style| style[:rating] }.reverse.first[:name]
  end

  #private
  def rated_styles
    ratings.map{ |r| r.beer.style_id }.uniq
  end
  def style_average(style)
    ratings_of_style = ratings.select{ |r| r.beer.style_id==style }
    ratings_of_style.inject(0.0){ |sum, r| sum+r.score}/ratings_of_style.count
  end
  def rated_breweries
    ratings.map{ |r| r.beer.brewery}.uniq
  end
  def brewery_average(brewery)
    ratings_of_brewery = ratings.select{ |r| r.beer.brewery==brewery }
    ratings_of_brewery.inject(0.0){ |sum, r| sum+r.score}/ratings_of_brewery.count
  end
  def rating_of_style(style)
    ratings_of_style = ratings.select do |r|
      r.beer.style == style
    end
    return nil if ratings_of_style.empty?
    ratings_of_style.map(&:score).sum / ratings_of_style.count
  end
  def rating_of_brewery(brewery)
    ratings_of_brewery = ratings.select do |r|
      r.beer.brewery == brewery
    end
    ratings_of_brewery.map(&:score).sum / ratings_of_brewery.count
  end


end
