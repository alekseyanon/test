require "spec_helper"

describe CommentsController do
  describe "routing" do
    #before { pending "***" }

    it "routes to #index" do
      get("/reviews/1/comments").should route_to("comments#index", :review_id => "1")
    end

    it "routes to #new" do
      get("/reviews/1/comments/new").should route_to("comments#new", :review_id => "1")
    end

    it "routes to #show" do
      get("/reviews/1/comments/1").should route_to("comments#show", :id => "1", :review_id => "1")
    end

    it "routes to #edit" do
      get("/reviews/1/comments/1/edit").should route_to("comments#edit", :review_id => "1", :id => "1")
    end

    it "routes to #create" do
      post("/reviews/1/comments").should route_to("comments#create", :review_id => "1")
    end

    it "routes to #update" do
      put("/reviews/1/comments/1").should route_to("comments#update", :id => "1", :review_id => "1")
    end

    it "routes to #destroy" do
      delete("/reviews/1/comments/1").should route_to("comments#destroy", :review_id => "1", :id => "1")
    end

  end
end
