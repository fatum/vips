require 'spec_helper'

describe Vips::Signal::Color do
  describe "#match?" do
    context "when el has child with another color" do
      let!(:root_element) { Vips::Dom::Element.new(tag_name: :body, color: "black") }
      let!(:element) { root_element.create_child(tag_name: :div, color: "white") }

      subject { described_class.match?(root_element) }

      it { should be_true }
    end

    context "when el hasn't" do
      let!(:root_element) { Vips::Dom::Element.new(tag_name: :html, color: "black") }
      let!(:element) { root_element.create_child(tag_name: :body, color: "black") }

      subject { described_class.match?(root_element) }

      it { should be_false }
    end
  end
end
