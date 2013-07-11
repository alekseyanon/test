require 'spec_helper'
require 'rake'

load File.join(Rails.root, 'Rakefile')

describe 'Event rake tasks' do

  let!(:event) { Event.make!(start_date: 1.day.ago) }

  it 'update event states' do
    Rake::Task['process_event_states'].invoke
    event.state.should == 'started'
  end

end
