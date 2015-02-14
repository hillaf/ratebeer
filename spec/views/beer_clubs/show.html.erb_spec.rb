require 'rails_helper'

RSpec.describe "beer_clubs/show", type: :view do
  before(:each) do
    @beer_club = assign(:beer_club, BeerClub.create!(
      :name => "Name",
      :founded => 1,
      :city => "City"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/City/)
  end
end
