# require 'rails_helper'
#
# RSpec.describe "styles/edit", type: :view do
#   before(:each) do
#     @style = assign(:style, Style.create!(
#       :name => "MyString",
#       :description => "MyText",
#       :beer_id => 1
#     ))
#   end
#
#   it "renders the edit style form" do
#     render
#
#     assert_select "form[action=?][method=?]", style_path(@style), "post" do
#
#       assert_select "input#style_name[name=?]", "style[name]"
#
#       assert_select "textarea#style_description[name=?]", "style[description]"
#
#       assert_select "input#style_beer_id[name=?]", "style[beer_id]"
#     end
#   end
# end
