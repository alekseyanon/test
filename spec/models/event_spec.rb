require 'spec_helper'

describe Event do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :landmark }

  let(:event) {Event.make! }
  let(:event_weekly){Event.make! repeat_rule: 'weekly'}

  it "после создания должен генерироваться первый оккажион" do
    event.event_occurrences.count.should == 1
  end

  describe 'Scheldule' do
    let(:e){ Event.new }
    it 'creates daily scheldule' do
      e.create_schedule(Time.now, 'daily').to_s.should == 'Daily'
    end
    it 'creates weekly scheldule' do
      e.create_schedule(Time.now, 'weekly').to_s.should == 'Weekly'
    end
    it 'creates monthly scheldule' do
      e.create_schedule(Time.now, 'monthly').to_s.should == 'Monthly'
    end
    it 'creates half-year scheldule' do
      e.create_schedule(Time.now, 'half-year').to_s.should == 'Every 6 months'
    end
    it 'creates yearly scheldule' do
      e.create_schedule(Time.now, 'yearly').to_s.should == 'Yearly'
    end
    it 'accessible' do
      e.create_schedule(Time.now, 'weekly')
      s = e.schedule
      s.exrule IceCube::Rule.monthly.day_of_month(13)
      e.schedule=s
      e.schedule.to_s.should == 'Weekly / not Monthly on the 13th day of the month'
    end
  end

  describe '.create_occurrences ' do    
    it "должен генерировать окажены на n месяцев вперед согласну правилу scheldule" do
      event_weekly.create_occurrences
      event_weekly.event_occurrences.count.should == 10
    end
  end
end
