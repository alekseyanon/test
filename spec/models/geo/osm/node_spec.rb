require 'spec_helper'

describe Geo::Osm::Node do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :geom }
end
