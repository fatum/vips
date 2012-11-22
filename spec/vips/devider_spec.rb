require 'spec_helper'

describe Vips::Divider do
  describe "#split", focus: true do
    context "when divide dom" do
      include_context :divider_body

      subject { described_class.new(Vips::Extractor::SIGNALS).split(body) }

      it { should be_instance_of(Vips::Block::Element) }

      its(:children) { should_not be_empty }

      it "t" do
#        binding.pry
      end
    end
  end
end
