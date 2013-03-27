# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Event do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :geom }
  it { should validate_presence_of :start_date }
  it { should belong_to :user }

  let(:event) {Event.make! }
  let(:event_weekly){Event.make! repeat_rule: 'weekly'}

  it { event.key.should_not be_empty }
  it { event.archive_at.should_not be_empty }

  describe 'multiple' do
    it 'creates next event then current was archived'
  end

  describe 'duration' do

    it 'can be calculated in days' do
      event = Event.make start_date: Time.now, end_date: 5.days.from_now
      event.duration.should == 5
      event = Event.make start_date: Time.now
      event.duration.should == 0
    end

    it 'cant be negative' do
      event = Event.make start_date: Time.now, end_date: 5.days.ago
      event.should_not be_valid
    end

    it 'must be more than 24 hours'
      event = Event.make start_date: Time.now, end_date: 23.hours.from_now
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 24.hours.from_now
      event.should be_valid
    end

    it 'еженедельного события <= 4 дней' do
      event = Event.make start_date: Time.now, end_date: 5.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 4.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'ежемесячного события <= 23 дней' do
      event = Event.make start_date: Time.now, end_date: 24.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 23.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'квартального события <= 60 дней' do
      event = Event.make start_date: Time.now, end_date: 61.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 60.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'ежегодного события <= 335 дней' do
      event = Event.make start_date: Time.now, end_date: 336.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 335.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'раз два года <= 700 дней' do
      event = Event.make start_date: Time.now, end_date: 336.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 335.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

    it 'раз три года <= 1065 дней' do
      event = Event.make start_date: Time.now, end_date: 1066.days.from_now, repeat_rule: 'weekly'
      event.should_not be_valid
      event = Event.make start_date: Time.now, end_date: 1065.days.from_now, repeat_rule: 'weekly'
      event.should be_valid
    end

  end

  it 'have RGeo Point Factory' do
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

    let!(:one){ Event.make! title: 'One two three', geom: Geo::factory.point(10, 10), start_date: Time.now }
    let!(:two){ Event.make! title: 'Two', body: 'One two three', geom: Geo::factory.point(11, 11), start_date: 35.days.ago }
    let!(:three){ Event.make! title: 'Three', body: 'Two three', geom: Geo::factory.point(9, 9), start_date: 14.days.ago, repeat_rule: 'weekly' }
    let!(:four){ Event.make! title: 'One two three', body: 'One two three four', geom: Geo::factory.point(10, 100), start_date: 7.days.from_now }

    it 'performs full text search in specified radius' do
      described_class.search(text: 'one', geom: one.geom, r: 5).should == [one, two]
      described_class.search(text: 'one', geom: one.geom, r: 101).should == [four, one, two]
    end

    it 'performs full text search in specified radius and date' do
      described_class.search(text: 'one', geom: one.geom, r: 5, date: [1.day.ago, 14.day.from_now]).should == [one]
    end
  end

  # describe 'Schedule' do
  #   let(:e){ Event.new }
  #   it 'creates weekly schedule' do
  #     e.create_schedule(Time.now, 'weekly').to_s.should == 'Weekly'
  #   end
  #   it 'creates monthly schedule' do
  #     e.create_schedule(Time.now, 'monthly').to_s.should == 'Monthly'
  #   end
  #   it 'creates half-year schedule' do
  #     e.create_schedule(Time.now, 'half-year').to_s.should == 'Every 6 months'
  #   end
  #   it 'creates yearly schedule' do
  #     e.create_schedule(Time.now, 'yearly').to_s.should == 'Yearly'
  #   end
  #   it 'accessible' do
  #     e.create_schedule(Time.now, 'weekly')
  #     s = e.schedule
  #     s.exrule IceCube::Rule.monthly.day_of_month(13)
  #     e.schedule=s
  #     e.schedule.to_s.should == 'Weekly / not Monthly on the 13th day of the month'
  #   end
  # end

end
