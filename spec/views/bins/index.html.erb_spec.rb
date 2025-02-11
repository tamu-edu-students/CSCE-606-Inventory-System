require 'rails_helper'

RSpec.describe "bins/index", type: :view do
  before(:each) do
    assign(:bins, [
      Bin.create!(
        name: "Name",
        location: "Location",
        category_name: "Category Name"
      ),
      Bin.create!(
        name: "Name",
        location: "Location",
        category_name: "Category Name"
      )
    ])
  end

  it "renders a list of bins" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Category Name".to_s), count: 2
  end
end
