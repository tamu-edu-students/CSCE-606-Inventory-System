require 'rails_helper'

RSpec.describe "bins/show", type: :view do
  before(:each) do
    assign(:bin, Bin.create!(
      name: "Name",
      location: "Location",
      category_name: "Category Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Category Name/)
  end
end
