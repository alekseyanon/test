require 'spec_helper'

describe AbstractDescription do
  subject { described_class.make! }
  it_behaves_like "an abstract description"
end
