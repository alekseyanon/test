# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Event do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :geom }
  it { should belong_to :user }

  let(:event) {Event.make! }
  let(:event_weekly){Event.make! repeat_rule: 'weekly'}

  it { event.key.should_not be_empty }
  it { event.archive_date.nil?.should be_false }
  it { event.archive_date.should_not be_blank }

  it '.multiple? works as expected' do
    event.multiple?.should be_false
    event_weekly.multiple?.should be_true
  end

  it '.update_state! change states and can raise errors' do
    e = Event.make start_date: 60.days.ago, end_date: 58.days.ago
    e.new?.should be_true
    e.update_state!
    e.started?.should be_true
    e.new?.should be_false
    e.update_state!
    e.ended?.should be_true
    e.update_state!
    e.archived?.should be_true
    expect{ e.update_state! }.to raise_error(RuntimeError)
  end

  describe 'multiple' do

    it 'creates next event then current was archived' do
      event_weekly.start
      event_weekly.stop
      event_weekly.archive
      event_weekly.archived?.should be_true
      Event.line(event_weekly.key).count.should == 2
    end

    it 'has some dynamic methods' do
      e1 = Event.make repeat_rule: :weekly
      e2 = Event.make repeat_rule: :monthly
      e1.weekly?.should be_true
      e2.monthly?.should be_true
    end

  end

  describe 'repeat_rule' do
    it 'always symbolized' do
      e = Event.make repeat_rule: 'monthly'
      e.repeat_rule.class.should == Symbol
      e.save!
      e = Event.first
      e.repeat_rule.class.should == Symbol
    end
  end

  describe 'duration' do

    it 'can be calculated in days' do
      event = Event.make start_date: Time.now, end_date: 5.days.from_now
      event.duration.to_i.should == 5
    end

    it 'cant be negative' do
      event = Event.make start_date: Time.now, end_date: 5.days.ago
      event.should_not be_valid
    end

    it 'must be more than 24 hours' do
      event = Event.make start_date: Time.now, end_date: 23.hours.from_now
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 24.hours.from_now
      event.should be_valid
    end

    it 'еженедельного события < 4 дней' do
      event = Event.make start_date: Time.now, end_date: 5.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 3.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'любого события < 20 дней' do
      event = Event.make start_date: Time.now, end_date: 19.days.from_now, repeat_rule: 'yearly'
      event.should be_valid
      event = Event.make start_date: Time.now, end_date: 23.days.from_now, repeat_rule: 'yearly'
      event.should_not be_valid
    end

  end

  it 'have RGeo point factory' do
    event.geom.class.should == RGeo::Geos::CAPIPointImpl
  end

  describe ".within_radius" do
    let(:triangle){ to_events [[10,10], [20,20], [30,10]] }

    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0].geom, 10).should =~ triangle[0..0]
      described_class.within_radius(triangle[0].geom, 15).should =~ triangle[0..1]
      described_class.within_radius(triangle[0].geom, 20).should =~ triangle
      described_class.within_radius(triangle[2].geom, 15).should =~ triangle[1..2]
    end
  end

  describe '.search' do
    let!(:d){ load_descriptions }

    it_behaves_like 'text search against title and body'

    let!(:one){
      Event.make!(
        title: 'One two three',
        geom: Geo::factory.point(10, 10),
        start_date: Time.now
      )
    }
    let!(:two){
      Event.make!(
        title: 'Two',
        body: 'One two three',
        geom: Geo::factory.point(11, 11),
        start_date: 35.days.ago,
        end_date: 33.days.ago
      )
    }
    let!(:three){
      Event.make!(
        title: 'Three',
        body: 'Two three',
        geom: Geo::factory.point(9, 9),
        start_date: 14.days.ago,
        end_date: 12.days.ago,
        repeat_rule: 'weekly'
      )
    }
    let!(:four){
      Event.make!(
        title: 'One two three',
        body: 'One two three four',
        geom: Geo::factory.point(10, 100),
        start_date: 7.days.from_now,
        end_date: 9.days.from_now
      )
    }

    it 'performs full text search in specified radius' do
      described_class.search(text: 'one', geom: one.geom, r: 5).should == [one, two]
      described_class.search(text: 'one', geom: one.geom, r: 101).should == [four, one, two]
    end

    it 'performs full text search in specified radius and date' do
      described_class.search(text: 'one', geom: one.geom, r: 5, date: [1.day.ago, 14.day.from_now]).should == [one]
    end
  end

end
