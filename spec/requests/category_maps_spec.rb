require 'rails_helper'

RSpec.describe "CategoryMaps", type: :request do
  describe "GET /category_maps" do
    it "works! (now write some real specs)" do
      get category_maps_path
      expect(response).to have_http_status(200)
    end
  end
end
