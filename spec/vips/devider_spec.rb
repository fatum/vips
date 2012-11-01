require 'spec_helper'

describe Vips::Divider do
  let!(:root_element) { Vips::Dom::Element.new(tag_name: :html) }
  let!(:element) { root_element.create_child(tag_name: :body) }

  let(:dom) { Vips::Dom::Collection.new([root_element]) }

  describe "#get_result" do
    context "when not found signals" do
      subject { described_class.new(dom, []).get_result }

      it { should be_instance_of(Vips::Pool) }
      it { should_not be_empty }

      it "s" do
        binding.pry
      end
    end
  end
end
