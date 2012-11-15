require 'spec_helper'

describe Vips::Extractor do
  def load_factory(page)
    page_hash = Digest::MD5.hexdigest(page)
    JSON.parse open(File.expand_path "../fixtures/#{page_hash}.dump", __FILE__).read, max_nesting: 1000
  end

  let(:page) { "http://forum.jquery.com/topic/how-to-isolate-text-nodes-in-jquery" }
  let(:page_structure) { described_class.prepare_bookmark_data(load_factory(page)) }

  describe "#prepare_bookmark_data" do
    subject { page_structure }

    it "should have valid structure" do
      subject.should have_key(:tag_name)
    end
  end

  describe "#build_dom_elements" do
    subject { described_class.build_dom_elements(page_structure) }

    it "should create valid elements collection" do
      first_children = subject.children.first
      first_children.parent.should == subject
    end
  end

  describe "#extract_blocks_from_dom", focus: true do
    let(:dom) { described_class.build_dom_elements(page_structure) }
    let!(:blocks) { described_class.extract_blocks_from_dom(dom) }

    it "should extract blocks" do
      puts "Blocks: #{blocks.count}"
      blocks.each do |block|
        puts "xpath: #{block.el.xpath}"
        puts "doc: #{block.doc}"
        #puts "level: #{block.level}"
      end
    end
  end
end
