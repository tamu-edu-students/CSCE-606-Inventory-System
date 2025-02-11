require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      name: "MyString",
      description: "MyString",
      created_date: "MyString",
      value: "MyString",
      bin_id: 1
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"

      assert_select "input[name=?]", "item[created_date]"

      assert_select "input[name=?]", "item[value]"

      assert_select "input[name=?]", "item[bin_id]"
    end
  end
end
