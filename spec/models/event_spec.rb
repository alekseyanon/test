require 'spec_helper'

describe Event do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :landmark }
  it "scheldule must be less than repeat period"
  it "после создания должен генерироваться первый оккажион"

  describe '.generate_occagions' do
    it "должен генерировать окажены на n месяцев вперед согласну правилу scheldule"
  end
end
