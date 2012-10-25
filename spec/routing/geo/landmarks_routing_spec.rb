require "spec_helper"

describe Geo::LandmarksController do
  describe "routing" do

    it "routes to #index" do
      get("/geo/landmarks").should route_to("geo/landmarks#index")
    end

    it "routes to #new" do
      get("/geo/landmarks/new").should route_to("geo/landmarks#new")
    end

    it "routes to #show" do
      get("/geo/landmarks/1").should route_to("geo/landmarks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/geo/landmarks/1/edit").should route_to("geo/landmarks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/geo/landmarks").should route_to("geo/landmarks#create")
    end

    it "routes to #update" do
      put("/geo/landmarks/1").should route_to("geo/landmarks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/geo/landmarks/1").should route_to("geo/landmarks#destroy", :id => "1")
    end

  end
end
