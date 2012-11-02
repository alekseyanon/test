require "spec_helper"

describe LandmarkDescriptionsController do
  describe "routing" do

    it "routes to #index" do
      get("/landmark_descriptions").should route_to("landmark_descriptions#index")
    end

    it "routes to #new" do
      get("/landmark_descriptions/new").should route_to("landmark_descriptions#new")
    end

    it "routes to #show" do
      get("/landmark_descriptions/1").should route_to("landmark_descriptions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/landmark_descriptions/1/edit").should route_to("landmark_descriptions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/landmark_descriptions").should route_to("landmark_descriptions#create")
    end

    it "routes to #update" do
      put("/landmark_descriptions/1").should route_to("landmark_descriptions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/landmark_descriptions/1").should route_to("landmark_descriptions#destroy", :id => "1")
    end

  end
end
