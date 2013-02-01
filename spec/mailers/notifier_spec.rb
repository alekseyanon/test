# fun coding: UTF-8

require "spec_helper"

describe Notifier do
  describe "signup_confirmation" do
    let(:user) { User.make! }
    let(:mail) { Notifier.signup_confirmation user }

    it "renders the headers" do
      pending
      mail.subject.should eq("Подтверждение регистрации")
      mail.to.should eq [user.email]
      mail.from.should eq %w(noreply@travel.com)
    end

    it "renders the body" #TODO consider using localization, maybe just /config/locales/ru.yml for now
  end

end
