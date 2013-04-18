# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Welcome", js: true, type: :request do

  it 'should show objects count number' do
    GeoObject.make!
    visit root_path
    sleep 5
    page.find('#objectsTotal').should have_content '1'
  end

end
