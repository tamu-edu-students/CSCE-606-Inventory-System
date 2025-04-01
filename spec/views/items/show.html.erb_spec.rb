require 'rails_helper'

RSpec.describe "items/show", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:bin) { create(:bin, user: user, location: location) }
  let!(:item) { create(:item, name: "Test Item", description: "Test Description", value: 150, bin: bin, user: user) }  # ✅ Ensure item has a user

  before do
    Rails.application.reload_routes!
    assign(:item, item)  # ✅ Assign `@item` to the view
  end

  context "when no images are attached" do
    before do
      render
    end

    it "sets the page title to the item name" do
      expect(view.content_for(:title)).to eq(item.name)
    end

    it "displays the item name" do
      expect(rendered).to have_selector("h1", text: item.name)
    end

    it "displays the item description" do
      expect(rendered).to have_text(item.description)
    end

    it "displays the formatted created date" do
      expect(rendered).to have_text(item.created_at.strftime("%B %d, %Y"))
    end

    it "shows the 'no picture uploaded' placeholder" do
      expect(rendered).to have_selector("i.fas.fa-image")
      expect(rendered).to have_text("No picture uploaded")
    end

    it "renders a back to items link" do
      expect(rendered).to have_link("Back to Items", href: items_path)
    end
  end

  context "when one image is attached" do
    before do
      item.item_pictures.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test.jpg")),
        filename: "test.jpg",
        content_type: "image/jpeg"
      )
      render
    end

    it "displays the main image" do
      expect(rendered).to have_selector("img.img-fluid.rounded")
    end

    it "does not show additional pictures section" do
      expect(rendered).not_to have_text("Additional Pictures")
    end
  end

  context "when multiple images are attached" do
    before do
      item.item_pictures.attach([
        {
          io: File.open(Rails.root.join("spec/fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        },
        {
          io: File.open(Rails.root.join("spec/fixtures/files/test2.jpg")),
          filename: "test2.jpg",
          content_type: "image/jpeg"
        }
      ])
      render
    end

    it "displays the main image" do
      expect(rendered).to have_selector("img.img-fluid.rounded")
    end

    it "displays the additional images section" do
      expect(rendered).to have_text("Additional Pictures")
      expect(rendered).to have_selector("img.img-thumbnail", count: item.item_pictures.count - 1)
    end
  end
end
