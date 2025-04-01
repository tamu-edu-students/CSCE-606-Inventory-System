require 'rails_helper'
RSpec.describe "locations/index", type: :view do
  let(:user) { create(:user) }
  let!(:locations) do
    create_list(:location, 2, user: user).each_with_index do |location, i|
      create_list(:bin, i + 1, location: location, user: user)
      create_list(:item, i + 2, bin: location.bins.first, user: user)
    end
  end

  before do
    Rails.application.reload_routes!
    assign(:locations, locations)
    assign(:location, Location.new) # needed for the modals
    render
  end

  it "sets the page title to 'Your Locations'" do
    expect(view.content_for(:title)).to eq("Your Locations")
  end

  it "includes the locations stylesheet" do
    expect(rendered).to include("stylesheet")
    expect(rendered).to include("locations")
  end

  it "renders a search input with correct id and placeholder" do
    expect(rendered).to have_selector("input#locationSearch[placeholder*='Search locations']")
  end

  it "renders a 'New Location' button" do
    expect(rendered).to have_selector("button.btn.btn-primary.addLocationBtn", text: /New Location/)
  end

  it "renders all location cards with correct data attributes" do
    locations.each do |location|
      expect(rendered).to have_selector(".location-card[data-name='#{location.name.downcase}']")
    end
  end

  it "renders the delete button with correct data attributes for each location" do
    locations.each do |location|
      expect(rendered).to have_selector("button.deleteLocationBtn[data-location-id='#{location.id}']")
      expect(rendered).to have_selector("button[data-bins='#{location.bins.count}']")
      expect(rendered).to have_selector("button[data-items='#{location.items.count}']")
    end
  end

  it "renders the edit button with correct data-location-id" do
    locations.each do |location|
      expect(rendered).to have_selector("button.editLocationBtn[data-location-id='#{location.id}']")
    end
  end

  it "renders a default image in each card" do
    expect(rendered).to have_selector("img[src*='default-bin'][width='50'][height='50']")
  end

  it "shows the bin and item counts as links when > 0" do
    locations.each do |location|
      if location.bins.count > 0
        expect(rendered).to have_link("#{pluralize(location.bins.count, 'Bin')}", href: bins_path(location_id: location.id))
      end
      if location.items.count > 0
        expect(rendered).to have_link("#{pluralize(location.items.count, 'Bin')}", href: items_path(location_id: location.id))
      end
    end
  end

  it "renders the 'Back to Dashboard' link" do
    expect(rendered).to have_link("Back to Dashboard", href: dashboard_path)
  end

  it "renders the add, edit, delete, and warning modals" do
    expect(rendered).to have_selector("#addLocationModal", visible: :all)
    expect(rendered).to have_selector("#editLocationModal", visible: :all)
    expect(rendered).to have_selector("#deleteLocationModal", visible: :all)
    expect(rendered).to have_selector("#warningModal", visible: :all)
  end

  it "includes the JavaScript file for locations" do
    expect(rendered).to match(/<script.*src=".*locations.*\.js".*>/)
  end
end
