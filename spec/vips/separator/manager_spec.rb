require 'spec_helper'

describe Vips::Separator::Manager do
  def stub_visual_block(n)
    double(width: n * 100, height: n * 50, vertical?: true)
  end

  let(:manager) { described_class.new }

  describe "set relative blocks" do
    let(:sep) { double('separator',
                         left: 20, top: 20,
                         vertical?: true,
                         horizontal?: false,
                         blocks: [],
                         width: 10, height: 100,
                         full_width: 120, full_height: 120
                        ) }

    before do
      sep.extend Vips::Polygon
      sep.extend Vips::Adjacent

      block.extend Vips::Polygon
    end

    describe "horizontal" do
      context "when separator adjacent to block" do
        let(:sep) { double('separator',
                         left: 20, top: 20,
                         vertical?: false,
                         horizontal?: true,
                         blocks: [],
                         width: 100, height: 40,
                         full_width: 120, full_height: 120
                        ) }

        let(:block) { double('block',
                           left: 40, top: 24,
                           vertical?: false,
                           horizontal?: true,
                           width: 60, height: 40,
                           full_width: 90, full_height: 90
                          ) }

        it "should add block to separator" do
          manager.separators << sep
          sep.should_receive(:blocks=).with([block])

          manager.set_relative_blocks([block])
        end
      end

      context "when separator not adjacent to block" do
        let(:sep) { double('separator',
                         left: 20, top: 20,
                         vertical?: false,
                         horizontal?: true,
                         blocks: [],
                         width: 100, height: 40,
                         full_width: 120, full_height: 120
                        ) }

        let(:block) { double('block',
                           left: 40, top: 25,
                           vertical?: false,
                           horizontal?: true,
                           width: 60, height: 40,
                           full_width: 90, full_height: 90
                          ) }

        it "should not add block to separator" do
          manager.separators << sep
          sep.should_receive(:blocks=).with([])

          manager.set_relative_blocks([block])
        end
      end
    end

    describe "vertical" do
      context "when separator adjacent to block" do
        let(:block) { double('block',
                           left: 22, top: 40,
                           vertical?: true,
                           width: 50, height: 60,
                           full_width: 90, full_height: 90
                          ) }

        it "should add block to separator" do
          manager.separators << sep
          sep.should_receive(:blocks=).with([block])

          manager.set_relative_blocks([block])
        end
      end

      context "when separator not adjacent to block" do
        let(:block) { double('block',
                           left: 40, top: 40,
                           vertical?: true,
                           width: 50, height: 60,
                           full_width: 90, full_height: 90
                          ) }

        it "should not add block to separator" do
          manager.separators << sep
          sep.should_receive(:blocks=).with([])

          manager.set_relative_blocks([block])
        end
      end
    end
  end

  describe "cross separators" do
    let(:sep) { double('separator',
                         left: 20, top: 20,
                         width: 100, height: 100,
                         full_width: 120, full_height: 120
                        ) }

    before do
      sep.extend Vips::Polygon
      block.extend Vips::Polygon
    end

    context "when block not cross separator" do
      let(:block) { double('block',
                         left: 40, top: 40,
                         width: 50, height: 50,
                         full_width: 90, full_height: 90
                        ) }

      subject { manager.block_cross_separator?(block, sep) }

      it { should be_false }
    end

    context "when block cross separator" do
      let(:block) { double('block',
                         left: 5, top: 40,
                         width: 50, height: 50,
                         full_width: 90, full_height: 90
                        ) }

      subject { manager.block_cross_separator?(block, sep) }

      it { should be_true }
    end
  end

  describe "contains" do
    let(:sep) { double('separator',
                         left: 20, top: 20,
                         width: 100, height: 100,
                         full_width: 120, full_height: 120
                        ) }
    let(:block) { double('block',
                         left: 40, top: 40,
                         width: 50, height: 50,
                         full_width: 90, full_height: 90
                        ) }

    before do
      sep.extend Vips::Polygon
      block.extend Vips::Polygon
    end

    context "when separator into block" do
      subject { manager.separator_contains_block?(block, sep) }

      it { should be_false }
    end

    context "when block into separator" do
      subject { manager.separator_contains_block?(sep, block) }

      it { should be_true }
    end
  end

  describe "#evaluate_block" do
    let(:sep) { double('separator',
                       left: 20, top: 20,
                       vertical?: false,
                       width: 100, height: 100,
                       blocks: [],
                       full_width: 120, full_height: 120
                      ) }
    let(:block) { double('block',
                         text_node?: false,
                         vertical?: true,
                         leaf_node?: true,
                         el: double("el", xpath: "xpath"),
                         left: 40, top: 40,
                         width: 50, height: 50,
                         full_width: 90, full_height: 90
                        ) }
    before do
      sep.extend Vips::Polygon
      sep.extend Vips::Adjacent

      block.extend Vips::Polygon

      manager.separators << sep
      manager.init_page(block)
    end

    context 'when separator contains block' do
      before do
        manager.should_receive(:split).twice
      end

      it "should remove separators" do
        manager.evaluate_block(block)
      end
    end

    context 'when block cover separator' do
      let(:block) { double('block',
                         text_node?: false,
                         vertical?: true,
                         leaf_node?: true,
                         el: double("el", xpath: "xpath"),
                         left: 0, top: 0,
                         width: 150, height: 150,
                         full_width: 150, full_height: 150
                        ) }

      it 'should remove separator' do
        manager.separators.should_receive(:delete)
        manager.evaluate_block(block)
      end
    end

    context 'when block across separator' do
      # sep(20, 20, 100, 100)
      let(:block) { double('block',
                         text_node?: false,
                         vertical?: true,
                         leaf_node?: true,
                         el: double("el", xpath: "xpath"),
                         left: 10, top: 10,
                         width: 150, height: 150,
                         full_width: 150, full_height: 150
                        ) }

      it 'should remove separator' do
        manager.separators.should_receive(:delete)

        manager.evaluate_block(block)
      end
    end
  end

  describe "#split" do
    let(:sep) { double('separator',
                       left: 0, top: 0,
                       vertical?: false,
                       width: 11, height: 11,
                       full_height: 11, full_width: 11,
                       attributes: {}
                      ) }
    let(:block) { double('block',
                         left: 1, top: 1,
                         width: 3, height: 3,
                         full_height: 4, full_width: 4
                        ) }

    before do
      sep.extend Vips::Polygon
      sep.extend Vips::Adjacent
      block.extend Vips::Polygon

      sep.should_receive(:top=).with(4)
      sep.should_receive(:height=).with(7)
    end

    it "should create valid separator" do
      manager.split(sep, block)
    end

    it "should create new separator" do
      -> {
        manager.split(sep, block)
      }.should change { manager.separators.count }.by(1)
    end

    it "should create valid separator" do
      manager.split(sep, block)
      manager.separators.last.height.should == block.top
    end
  end

  describe "#expand_separator" do
    before do
      3.times do |n|
        block = stub_visual_block(n)

        block.should_receive(:height=)

        manager.init_page(block)
        manager.separators << block
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

      it "should set page sizes at biggest block" do
        blocks.each { |b| manager.init_page(b) }

        manager.page.width.should == 200
        manager.page.height.should == 100
      end
    end
  end
end
