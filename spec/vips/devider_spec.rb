require 'spec_helper'

describe Vips::Divider do
  let!(:root_element) { Vips::Dom::Element.new(tag_name: :html) }
  let!(:element) { root_element.create_child(tag_name: :body) }

  let(:dom) { root_element }

  describe "#get_result" do
    context "when not found signals" do
      subject { described_class.new(dom, []).get_result }

      it { should be_instance_of(Vips::Pool) }

      it { should_not be_empty }

      it "should have elements with doc" do
        subject.first.doc.should_not be_nil
        subject.first.level.should_not be_nil
        subject.first.el.should_not be_nil
      end
    end
  end
end
