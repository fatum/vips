require 'spec_helper'

describe Vips::Separator::Manager do
  def stub_visual_block(n)
    double(width: n * 100, height: n * 50, vertical?: true)
  end

  let(:manager) { described_class.new }

  describe "#split", focus: true do
    let(:sep) { double('separator',
                       left: 20, top: 20,
                       width: 100, height: 100
                      ) }
    let(:block) { double('block',
                         left: 40, top: 40,
                         width: 50, height: 50
                        ) }

    before do
      sep.should_receive(:width=).with(20)
    end

    it "should create valid separator" do
      separator = manager.split(sep, block)
      separator.width.should == 30
      separator.height.should == 100
      separator.left.should == 90
      separator.top.should == 20
    end

    it "should split vertical" do
      -> {
        manager.split(sep, block)
      }.should change { manager.count }.by(1)
    end
  end

  describe "#expand_separator", focus: true do

    before do
      3.times do |n|
        block = stub_visual_block(n)

        block.should_receive(:height=)

        manager.init_page(block)
        manager << block
      end
    end

    it "should expand separator size" do
      manager.expand_separator()
    end
  end

  describe "#init_page" do
    context "when we iterate each block" do
      let(:blocks) do
        3.times.map { |n| stub_visual_block(n) }
      end

      it "should set page sizes at biggest block", focus: true do
        blocks.each { |b| manager.init_page(b) }

        manager.page.width.should == 200
        manager.page.height.should == 100
      end
    end
  end
end
