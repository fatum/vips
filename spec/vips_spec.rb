require 'json'
require 'spec_helper'

describe Vips::Extractor do
  def load_factory(page)
    page_hash = Digest::MD5.hexdigest(page)
    JSON.parse open(File.expand_path "../fixtures/#{page_hash}.dump", __FILE__).read, max_nesting: 1000
  end

  let(:page) { "http://forum.jquery.com/topic/how-to-isolate-text-nodes-in-jquery" }
  let(:extractor) { described_class.new(load_factory(page)) }

  describe "#dom" do
    subject { extractor.dom }

    it "should have valid structure" do
      subject.should have_key(:tag_name)
    end
  end

  describe "#elements" do
    subject { extractor.elements }

    it "should create valid elements collection" do
      first_children = subject.children.first
      first_children.parent.should == subject
    end
  end
end
