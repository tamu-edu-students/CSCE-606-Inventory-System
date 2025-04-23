require 'rails_helper'

RSpec.describe "items/index", type: :view do
  let!(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let!(:bins) { create_list(:bin, 2, user: user, location: location) } 
  let!(:items) { create_list(:item, 2, bin: bins.first, user: user) }  # ✅ Fix: Ensure items have a user

  before do
    Rails.application.reload_routes!
    assign(:items, items)  # ✅ Assign `@items` to the view
    assign(:bins, bins)  # ✅ Assign bins in case the view references them
    allow(view).to receive(:current_user).and_return(user)
    render
  end

  it "renders the filter input with id 'filterInput'" do
    render
    expect(rendered).to have_selector("input#filterInput")
  end

  it "renders the value filter input with id 'valueFilter'" do
    render
    expect(rendered).to have_selector("input#valueFilter")
  end

  it "renders the reset button with id 'resetFilters'" do
    render
    expect(rendered).to have_selector("button#resetFilters")
  end

  it "sets the page title to 'Items'" do
    expect(view.content_for(:title)).to eq("Items")
  end

  it "renders the 'New Item' button with the correct link" do
    expect(rendered).to have_link("New Item", href: new_item_path)
  end

  it "renders a list of items when @items is present" do
    expect(rendered).to have_selector(".item-card", count: items.size)
  end

  it "renders each item card with correct data attributes" do
    items.each do |item|
      expect(rendered).to have_selector(".item-card[data-name='#{item.name.downcase}'][data-value='#{item.value.to_f}']")
    end
  end

  it "renders a delete button for each item" do
    items.each do |item|
      expect(rendered).to have_selector("form[action='#{item_path(item)}'][method='post'] button", text: "")
    end
  end

  it "renders an edit button for each item" do
    items.each do |item|
      expect(rendered).to have_link(href: edit_item_path(item))
    end
  end

  it "renders item details correctly" do
    items.each do |item|
      expect(rendered).to have_link(item.name, href: item_path(item))
      expect(rendered).to have_text(item.bin&.name || "Unassigned")
      expect(rendered).to have_text(item.bin&.location&.name || item.location&.name || "Unassigned")
      expect(rendered).to have_text(number_to_currency(item.value))
    end
  end

  it "renders a message when there are no items" do
    assign(:items, [])
    render
    expect(rendered).to have_selector("h3", text: "No items yet")
  end

  it "renders an 'Add Item' button when there are no items" do
    assign(:items, [])
    render
    expect(rendered).to have_link("Add Item", href: new_item_path)
  end

  it "renders the 'Back to Dashboard' button with the correct link" do
    expect(rendered).to have_link("Back to Dashboard", href: dashboard_path)
  end


  it "renders a responsive grid layout for items" do
    expect(rendered).to have_selector(".row.row-cols-1.row-cols-sm-2.row-cols-md-3.g-4")
  end

  it "renders the default image for each item" do
    items.each do |item|
      puts asset_path('items.js')
      expect(rendered).to have_selector("img[src*='default-bin'][width='50'][height='50']")
    end
  end

  it "renders buttons and links with appropriate classes" do
    expect(rendered).to have_selector("button.btn.btn-sm.btn-danger")
    expect(rendered).to have_selector("a.btn.btn-sm.btn-warning")
    expect(rendered).to have_selector("a.btn.btn-primary")
  end
end
