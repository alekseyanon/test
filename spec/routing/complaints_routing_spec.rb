require "spec_helper"

describe ComplaintsController do
  describe "routing" do

    it "routes to #index" do
      get("/reviews/1/complaints").should route_to("complaints#index", review_id: "1")
    end

    it "routes to #new" do
      get("/reviews/1/complaints/new").should route_to("complaints#new", review_id: "1")
    end

    it "routes to #create" do
      post("/reviews/1/complaints").should route_to("complaints#create", review_id: "1")
    end

    it "routes to #destroy" do
      delete("/reviews/1/complaints/1").should route_to("complaints#destroy", review_id: "1", :id => "1")
    end

    it "routes to #index" do
      get("/reviews/1/comments/1/complaints").should route_to("complaints#index", review_id: "1", comment_id: "1")
    end

    it "routes to #new" do
      get("/reviews/1/comments/1/complaints/new").should route_to("complaints#new", review_id: "1", comment_id: "1")
    end

    it "routes to #create" do
      post("/reviews/1/comments/1/complaints").should route_to("complaints#create", review_id: "1", comment_id: "1")
    end

    it "routes to #destroy" do
      delete("/reviews/1/comments/1/complaints/1").should route_to("complaints#destroy", review_id: "1", :id => "1", comment_id: "1")
    end

  end
end
