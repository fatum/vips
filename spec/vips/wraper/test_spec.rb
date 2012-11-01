require 'spec_helper'

describe Vips::Wraper::Test do
  describe "#goto" do
    subject { described_class.new.goto('http://amazon.dom') }

    it { should be_instance_of(Vips::Dom::Collection) }
  end

  describe "#quit" do
  end
end
