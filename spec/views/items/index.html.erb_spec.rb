require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        name: "Name",
        description: "Description",
        created_date: "Created Date",
        value: "Value",
        bin_id: 2
      ),
      Item.create!(
        name: "Name",
        description: "Description",
        created_date: "Created Date",
        value: "Value",
        bin_id: 2
      )
    ])
  end

  it "renders a list of items" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Created Date".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Value".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
