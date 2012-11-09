require 'spec_helper'

describe Vips::Extractor do
  def load_factory(page)
    page_hash = Digest::MD5.hexdigest(page)
    JSON.parse open(File.expand_path "../fixtures/#{page_hash}.dump", __FILE__).read, max_nesting: 1000
  end

  describe "#prepare_bookmark_data" do
    let(:page) { "http://forum.jquery.com/topic/how-to-isolate-text-nodes-in-jquery" }
    subject { described_class.prepare_bookmark_data(load_factory(page)) }

    it "should have valid node structure" do
      subject.should have_key(:tag_name)
    end
  end
end
