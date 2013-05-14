require "spec_helper"

describe FeedbackMailer do
  describe "feedback_information" do
    let(:mail) { FeedbackMailer.feedback_information }

    it "renders the headers" do
      mail.subject.should eq("Feedback information")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
