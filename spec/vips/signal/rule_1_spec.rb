require 'spec_helper'

describe Vips::Signal::Rule1 do
  describe "#match?" do
    let!(:root_element) { Vips::Dom::Element.new(tag_name: :body, color: "black", visible?: true) }
    let!(:element) { root_element.create_child(
      tag_name: :div, color: "white", text: "Some text", visible?: true
    ) }

    context "when text node" do
      subject { described_class.match?(element, 0) }

      it { should be_false }
    end

    context "when not text node" do
      subject { described_class.match?(root_element, 0) }

      it { should be_true }
    end
  end
end
