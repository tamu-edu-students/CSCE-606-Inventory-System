require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) {
    Item.create!(
      name: "MyString",
      description: "MyString",
      created_date: "MyString",
      value: "MyString",
      bin_id: 1
    )
  }

  before(:each) do
    assign(:item, item)
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"

      assert_select "input[name=?]", "item[created_date]"

      assert_select "input[name=?]", "item[value]"

      assert_select "input[name=?]", "item[bin_id]"
    end
  end
end
