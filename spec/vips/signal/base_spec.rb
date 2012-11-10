require 'spec_helper'

describe Vips::Signal::Base do
  class TestSignal
    extend Vips::Signal::Base
  end


  let!(:inline_element) do
    Vips::Dom::Element.new(
      tag_name: :b, color: "black", visible?: true,
      width: 10, height: 20
    )
  end

  let!(:inline_element_with_text) do
    Vips::Dom::Element.new(
      tag_name: :b, color: "black", visible?: true, text: "Some text",
      width: 20, height: 20
    )
  end

  describe "#get_calculated_doc" do
  end

  describe "#small_node?" do
    let(:fake) { double(width: 10, height: 20) }

    subject { TestSignal.small_node?(fake) }

    it { should be_true }

    context "when big enough" do
      let(:fake) { double(width: 1024, height: 500) }

      it { should be_false }
    end
  end

  describe "#get_size" do
    subject { TestSignal.get_size(inline_element) }

    it { should == 200 }

    context "when children size more then parent" do
      before do
        inline_element.add_child(inline_element_with_text)
      end

      it { should == 400 }
    end
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
