require 'rails_helper'

RSpec.describe "bins/new", type: :view do
  before(:each) do
    assign(:bin, Bin.new(
      name: "MyString",
      location: "MyString",
      category_name: "MyString"
    ))
  end

  it "renders new bin form" do
    render

    assert_select "form[action=?][method=?]", bins_path, "post" do

      assert_select "input[name=?]", "bin[name]"

      assert_select "input[name=?]", "bin[location]"

      assert_select "input[name=?]", "bin[category_name]"
    end
  end
end
