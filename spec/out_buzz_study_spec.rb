require "spec_helper"

describe Fluent::BuzzStudy do
  let(:buzz_study) do
    buzz_study = described_class.new
    buzz_study.instance_eval do |c|
      c.mongo_collection = "uri"
    end
    buzz_study
  end

  describe ".get_page_title" do
    context "shorten uri" do
      subject do
        buzz_study.send(:get_page_title, "http://htn.to/sMTTfL")
      end
      let(:expected){ "オープンセミナー2014@広島 - オープンセミナー広島 | Doorkeeper" }
      it { should eq expected }
    end
  end
end
