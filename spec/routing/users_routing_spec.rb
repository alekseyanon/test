require "spec_helper"

describe UsersController do
  describe "routing" do

    it "routes to #index" do
      get("/users").should route_to("users#index")
    end

    it "routes to #new" do
      get("/signup/traveler").should route_to("users#new", :type => "traveler")
    end

    it "routes to #edit" do
      get("/users/1/edit").should route_to("users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/users").should route_to("users#create")
    end

    it "routes to #update" do
      put("/users/1").should route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/users/1").should route_to("users#destroy", :id => "1")
    end

    it "routes to #new_via_oauth" do
      get("/users/new/new_via_oauth").should route_to("users#new_via_oauth")
    end

    it "routes to #create_via_oauth" do
      post("/users/new/create_via_oauth").should route_to("users#create_via_oauth")
    end
  end
end
