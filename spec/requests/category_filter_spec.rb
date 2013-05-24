require 'spec_helper'
Capybara.save_and_open_page_path = "/tmp/smorodina"


describe "Category filter", js: true, type: :request do

  before(:each) do
    visit root_path
  end

  def find_category name
    find "li span[data-facet=#{name}]"
  end

  def click_category name
    find_category(name).click
  end

  def click_emblem name
    find("button[data-facet=#{name}]").click
  end

  def switch_tunmbler
    find('.search-filter__switcher__button').click
    sleep 0.5
  end

  def semi_selected
    page.all('.semi-selected')
  end

  def fetch_category_by_name name
    Category.find(:first, conditions: { name: name })
  end

  def fetch_subcategories_count category_name, opts = {}
    count = fetch_category_by_name(category_name).descendants.length
    count + 1 if opts[:include_self]
  end

  def semi_selected_elems_on_page
    page.all('.semi-selected', visible: true).length
  end

  context "Emblem buttons and tumbler semi-selection" do

    it "shows and semi-selects all categories of certain type when clicked on an Emblem button" do
      click_emblem   'lodging'
      elems_on_server = fetch_category_by_name('lodging').self_and_descendants.length
      elems_on_server.should == semi_selected_elems_on_page
    end

    it "shows ALL categoris when tumbler is switched" do
      switch_tunmbler

      %w(sightseeing activities food lodging).reduce(0) do |sum, c|
        sum + fetch_category_by_name(c).self_and_descendants.length
      end.should == semi_selected_elems_on_page

    end

  end

  context "selection testing" do

    before(:each) { click_emblem 'activities' }
    
    # При выделении элемента, все его полувыделенные родители
    # (и соседи этих родителей, включая их детей) теряют выделение и обводятся в рамку
    it "selects a category" do
      page.all('.semi-selected').size.should == fetch_category_by_name('activities').self_and_descendants.size
      click_category 'downhill_with_ski-lift'
      page.all('li.selected').size.should      == 1
      page.all('.semi-selected').size.should   == 0
      page.should have_selector('li.selected span[data-facet=downhill_with_ski-lift]')
      bordered_categories = fetch_category_by_name('downhill_with_ski-lift').ancestors
      # '+ 1' means that root category is not shown on page
      bordered_categories.length.should == page.all('.bordered').length + 1
    end
    
    # При выделении родительского элемента, его потомки становятся полувыделенными
    it "selects a parent category" do
      click_category 'in_the_mountains'
      fetch_category_by_name('in_the_mountains').descendants.size.should == page.all('.semi-selected').size
    end
    
    # При выделении всех детей в некоторый подкатегории, 
    # их родитель становится выделенным
    it "selects all children in some category" do
      click_category 'downhill_without_ski-lift'
      click_category 'downhill_with_ski-lift'
      page.all('li.selected').size.should == 3
      page.should have_selector('li.selected span[data-facet=downhill_skiing_boarding]')
    end

  end

end
