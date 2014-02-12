require "spec_helper"

describe Fluent::BuzzStudy do
  let(:buzz_study) do
    buzz_study = described_class.new
    buzz_study.instance_eval do |c|
      c.mongo_collection = "uri"
    end
    buzz_study
  end

  describe "#add_record" do
    context "shorten uri" do
      subject do
        buzz_study.send(:add_record, "http://htn.to/sMTTfL")
      end
      let(:expected){ "オープンセミナー2014@広島 - オープンセミナー広島 | Doorkeeper" }
      it "returns updated record." do
        result = subject
        result["title"].should eq expected
        result["count"].should > 0
      end
    end
  end
end
