require 'spec_helper'

describe Article do
  subject { described_class.make! }
  it_behaves_like "an article"
end
