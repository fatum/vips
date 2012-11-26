require 'spec_helper'

describe Vips::Divider do
  describe "#split" do
    context "when divide dom" do
      include_context :divider_body

      subject { described_class.new(Vips::Extractor::SIGNALS).divide!(body.el) }

      it { should_not be_empty }
    end
  end
end
