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
    SearchQuery.add 'привед, медведик'
    SearchQuery.add 'привед, медведик'
    SearchQuery.add 'хали гали паратрупер'
    SearchQuery.popular_for('вед').should == ['привед, медведик', 'привед, медвед']
  end

  it "tracks history of queries" do
    user = User.make!
    SearchQuery.add 'Привед, Медвед', user
    SearchQuery.add 'привед, медведик', user
    SearchQuery.add 'хали гали паратрупер', user
    SearchQuery.history_for_user(user, 2).should == ['хали гали паратрупер', 'привед, медведик']
  end

end
