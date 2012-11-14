require 'spec_helper'

describe Geo::Osm::Poly do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :tags }
  it { should validate_presence_of :nodes }
end
