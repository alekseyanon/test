require "spec_helper"

describe LandmarksController do
  describe "routing" do

    it "routes to #index" do
      get("/landmarks").should route_to("landmarks#index")
    end

    it "routes to #new" do
      get("/landmarks/new").should route_to("landmarks#new")
    end

    it "routes to #show" do
      get("/landmarks/1").should route_to("landmarks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/landmarks/1/edit").should route_to("landmarks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/landmarks").should route_to("landmarks#create")
    end

    it "routes to #update" do
      put("/landmarks/1").should route_to("landmarks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/landmarks/1").should route_to("landmarks#destroy", :id => "1")
    end

  end
end
