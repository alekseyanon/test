require 'spec_helper'

describe LandmarkDescription do
  subject { described_class.make! }
  it_behaves_like "an article"
  it { should belong_to :landmark }
end
