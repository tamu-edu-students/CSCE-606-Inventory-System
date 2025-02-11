require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    assign(:item, Item.create!(
      name: "Name",
      description: "Description",
      created_date: "Created Date",
      value: "Value",
      bin_id: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Created Date/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(/2/)
  end
end
