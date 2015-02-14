require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "has a password long enough" do
    user = User.create username:"Pekka", password:"he1", password_confirmation:"he1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "has a password with numbers" do
    user = User.create username:"Pekka", password:"Heihei", password_confirmation:"Heihei"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

    describe "favorite beer" do
      let(:user){FactoryGirl.create(:user) }

      it "has method for determining one" do
        user.should respond_to :favorite_beer
      end

      it "without ratings does not have one" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one rating" do
        beer = FactoryGirl.create(:beer)
        rating = FactoryGirl.create(:rating, beer:beer, user:user)

        expect(user.favorite_beer).to eq(beer)
      end

      it "is the one with highest rating if several rated" do
        create_beer_with_rating(10, user)
        best = create_beer_with_rating(25, user)
        create_beer_with_rating(7, user)

        expect(user.favorite_beer).to eq(best)
      end

    end

    describe "favorite style" do
      let(:user){FactoryGirl.create(:user) }
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end
      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end
      it "is the style of the only rated if one rating" do
        create_beers_with_ratings_and_style(10, "Lager", user)
        expect(user.favorite_style).to eq("Lager")
      end
      it "is the style with highest average rating if several rated" do
        create_beers_with_ratings_and_style(10, 20, 15, "Lager", user)
        create_beers_with_ratings_and_style(35, "IPA", user)
        create_beers_with_ratings_and_style(25, 20, 15, "Porter", user)
        expect(user.favorite_style).to eq("IPA")
      end
    end
    describe "favorite brewery" do
      let(:user){FactoryGirl.create(:user) }
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_brewery)
      end
      it "without ratings does not have one" do
        expect(user.favorite_brewery).to eq(nil)
      end
      it "is the brewery of only rated if one rating" do
        brewery = FactoryGirl.create(:brewery, name:"Koff")
        create_beers_with_ratings_and_brewery(10, brewery, user)
        expect(user.favorite_brewery).to eq(brewery)
      end
      it "is the brewery with highest average rating if several rated" do
        plevna = FactoryGirl.create(:brewery, name:"Plevna")
        create_beers_with_ratings_and_brewery(10, 20, 15, FactoryGirl.create(:brewery), user)
        create_beers_with_ratings_and_brewery(35, plevna , user)
        create_beers_with_ratings_and_brewery(25, 20, 15, FactoryGirl.create(:brewery), user)
        expect(user.favorite_brewery).to eq(plevna)
      end
    end
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beers_with_ratings_and_brewery(*scores, brewery, user)
  create_beers(scores, "Pale Ale", brewery, user)
end

def create_beers_with_ratings_and_style(*scores, style, user)
  create_beers(scores, style, Brewery.new, user)
end

def create_beers(scores, style, brewery, user)
  scores.each do |score|
    create_beer(score, style, brewery, user)
  end
end
def create_beer(score, style, brewery, user)
  beer = FactoryGirl.create(:beer, style:style, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
