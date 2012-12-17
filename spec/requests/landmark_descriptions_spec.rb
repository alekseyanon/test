# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'pp'
describe "LandmarkDescriptions", js: true, type: :request do
  self.use_transactional_fixtures = false
  before do 
    @c1 = Category.make!
    @c2 = Category.make!
    @user = User.make!
    visit profile_path(:type => 'traveler')
    fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
    # sleep(10)
    current_path.should == root_path
  end

  it "landmark description new" do 
    visit profile_path(:type => 'traveler')
    visit new_landmark_description_path
    tmp = Faker::Lorem.word
    fill_in 'landmark_description_title', with: tmp
    sleep(1)
    find('#map').click
    # sleep(3)
    # pp "===============after click"
    #select @c1.name_ru, from: 'landmark_description_tag_list'
    click_on 'Создать объект'
    page.should have_content(tmp.to_s)
    sleep(5)
  end

  # it "waiting for updating db to check edit form" do
  #   visit new_landmark_description_path
  #   tmp = Faker::Lorem.word
  #   fill_in 'landmark_description_title', with: tmp
  #   select @c1.name_ru, from: 'landmark_description_tag_list'
  #   click_on 'Создать объект'
  #   page.should have_content(tmp.to_s)
  #   click_on 'Edit'
  #   tmp = Faker::Lorem.word
  #   fill_in 'landmark_description_title', with: tmp
  #   select @c2.name_ru, from: 'landmark_description_tag_list'
  #   click_on 'Применить изменения'
  #   page.should have_content(tmp.to_s)
  # end
  
end
# #, type: :request
# describe "LandmarkDescriptions testing with js", js: true, type: :request  do 
#   self.use_transactional_fixtures = false
#   it "test login" do 
#     @category = Category.make!
#     @user = User.make!
#     visit profile_path(:type => 'traveler')
#     fill_in 'user_session[email]', with: @user.email
#     fill_in 'user_session[password]', with: @user.password
#     click_on 'Войти'
#     sleep(4)
#     current_path.should == root_path
#   end

# end

