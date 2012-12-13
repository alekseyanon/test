require 'spec_helper'

#TODO cover weighting
#TODO cover multi-word search
describe AbstractDescription do
  subject { described_class.make! }
  it_behaves_like "an abstract description"
end
