#encoding: utf-8
require 'spec_helper'

describe SearchQuery do

  it 'counts search queries' do
    SearchQuery.add 'Привед, Медвед'
    SearchQuery.add 'привед, медвед'
    SearchQuery.add 'привед, медведик'
    SearchQuery.find_by_str('привед, медвед').counter.should == 2
  end

  it '.popular_for returns popular queries' do
    SearchQuery.add 'Привед, Медвед'
    SearchQuery.add 'привед, медвед'
    SearchQuery.add 'привед, медведик'
    SearchQuery.add 'хали гали паратрупер'
    SearchQuery.popular_for('вед').should == ['привед, медвед', 'привед, медведик']
  end

end
