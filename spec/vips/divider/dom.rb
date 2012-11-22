#require 'spec_helper'

describe Vips::Divider::Dom do
  let(:block) do
    double(:block, {
      el: double(:element, {
        width: 1024, height: 768,
        left: 0, top: 0
      })
    })
  end

  let(:level) { 0 }

  subject { described_class.new(block, level) }

  context "when block dividable" do
    include_context :divider_body

    it "should check to divide dom children" do
      subject.divide!(Vips::Extractor::SIGNALS)
    end

    it "should add each children to blocks" do
    end
  end

  context "when block not dividable" do
    before do
      block.should_receive(:doc)
      block.should_receive(:doc=)
    end

    it "should add it to blocks list" do
      -> {
        subject.divide!([])
      }.should change { subject.blocks.count }.by(1)
    end
  end
end
