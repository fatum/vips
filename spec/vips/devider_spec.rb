require 'spec_helper'

describe Vips::Divider do
  let(:element) { double(:element, tag_name: "div") }

  let(:dom) { Vips::Dom::Collection.new([
    element, element, element
  ]) }

  describe "#get_result" do
    context "when not found signals" do
      subject { described_class.new(dom, []).get_result }

      it { should be_instance_of(Vips::Pool) }
    end
  end
end
