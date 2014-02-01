require "spec_helper"

describe Fluent::BuzzStudy do
  describe ".get_page_title" do
    context "shorten uri" do
      subject do
        described_class.new.send(:get_page_title, "http://htn.to/sMTTfL")
      end
      let(:expected){ "オープンセミナー2014@広島 - オープンセミナー広島 | Doorkeeper" }
      it { should eq expected }
    end
  end
end
