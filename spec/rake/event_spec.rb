require 'spec_helper'
require 'rake'

load File.join(Rails.root, 'Rakefile')

describe 'Event rake tasks' do

  let!(:event) { Event.make!(start_date: 1.day.ago) }

  it 'update event states' do
    event.state.should == 'new'
    Event.process_states
    event.reload
    event.state.should == 'started'
  end

end
