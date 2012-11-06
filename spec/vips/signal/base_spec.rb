require 'spec_helper'

describe Vips::Signal::Base do
  class TestSignal
    extend Vips::Signal::Base
  end


  let!(:inline_element) { Vips::Dom::Element.new(tag_name: :b, color: "black", visible?: true) }
  let!(:inline_element_with_text) do
    Vips::Dom::Element.new(tag_name: :b, color: "black", visible?: true, text: "Some text")
  end

  describe "#inline_node" do
    subject { TestSignal.inline_node?(inline_element) }

    it { should be_true }
  end

  describe "#text_node" do
    context "when node without text" do
      subject { TestSignal.text_node?(inline_element) }

      it { should be_false }
    end

    context "when node with text" do
      subject { TestSignal.text_node?(inline_element_with_text) }

      it { should be_true }
    end
  end

  describe "#virtual text node" do
    subject { TestSignal.virtual_text_node?(inline_element) }

    context "when element inline node" do
      it { should be_false }
    end
  end
end
