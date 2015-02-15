require 'rails_helper'

describe Beer do
  it "has a name" do
    beer = Beer.create style_id:1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "has style" do
    beer = Beer.create name:"Herkkuolut"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  describe "with proper name and style" do

    it "is saved" do
    beer = Beer.create name:"Herkkuolut", style_id:1

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
    end
  end

end
