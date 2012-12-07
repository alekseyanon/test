# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "LandmarkDescriptions" do
  # before do 
  #   @user = LandmarkDescription.make!
  # end
  before do 
    @user = User.make!
    visit profile_path(:type => 'traveler')
    fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
    current_path.should == root_path
  end

  it "landmark description new" do 
    visit new_landmark_description_path
    tmp = Faker::Lorem.word
    fill_in 'landmark_description_title', with: tmp
    select Category.find(12).name_ru, from: 'landmark_description_tag_list'
    click_on 'Создать объект'
    page.should have_content(tmp.to_s)
  end

  it "waiting for updating db to check edit form" do
    visit new_landmark_description_path
    tmp = Faker::Lorem.word
    fill_in 'landmark_description_title', with: tmp
    select Category.find(12).name_ru, from: 'landmark_description_tag_list'
    click_on 'Создать объект'
    page.should have_content(tmp.to_s)
    click_on 'Edit'
    tmp = Faker::Lorem.word
    fill_in 'landmark_description_title', with: tmp
    select Category.find(13).name_ru, from: 'landmark_description_tag_list'
    click_on 'Применить изменения'
    page.should have_content(tmp.to_s)
  end
end

