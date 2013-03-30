require 'spec_helper'

describe Api::EventsController do

  describe "GET week" do
    it "sucsess" do
      get :week
      expect(response).to be_success
    end
  end

  describe "GET tags" do
    it "sucsess" do
      get :tags
      expect(response).to be_success
    end
  end

  describe "GET search" do
    it "sucsess" do
      get :search
      expect(response).to be_success
    end
  end

  it 'возвращает события в json с нужными атрибутами'
  it 'производит поиск событий с учетом переданных параметров'

end
