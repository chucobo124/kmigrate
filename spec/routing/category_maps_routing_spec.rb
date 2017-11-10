require "rails_helper"

RSpec.describe CategoryMapsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/category_maps").to route_to("category_maps#index")
    end

    it "routes to #new" do
      expect(:get => "/category_maps/new").to route_to("category_maps#new")
    end

    it "routes to #show" do
      expect(:get => "/category_maps/1").to route_to("category_maps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/category_maps/1/edit").to route_to("category_maps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/category_maps").to route_to("category_maps#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/category_maps/1").to route_to("category_maps#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/category_maps/1").to route_to("category_maps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/category_maps/1").to route_to("category_maps#destroy", :id => "1")
    end

  end
end
