require 'rails_helper'

RSpec.describe "beer_clubs/index", type: :view do
  before(:each) do
    assign(:beer_clubs, [
      BeerClub.create!(
        :name => "Name",
        :founded => 1,
        :city => "City"
      ),
      BeerClub.create!(
        :name => "Name",
        :founded => 1,
        :city => "City"
      )
    ])
  end

  it "renders a list of beer_clubs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
  end
end
