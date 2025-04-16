class SearchController < ApplicationController
  before_action :authenticate_user! # Ensure only logged-in users can access

  def index
    bins = current_user.bins.select(:id, :name, :category_name)
    locations = current_user.locations.select(:id, :name)
    items = current_user.items.select(:id, :name)

    # Combine results into a single JSON response
    search_results = {
      bins: bins.as_json(only: [:id, :name, :category_name]),
      locations: locations.as_json(only: [:id, :name]),
      items: items.as_json(only: [:id, :name])
    }

    render json: search_results
  end
end
