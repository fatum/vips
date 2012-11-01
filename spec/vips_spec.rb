require 'spec_helper'

describe Vips do
  describe "#get_driver" do
    describe "test driver" do
      subject { Vips.get_driver(:test) }

      it { should be_instance_of(Vips::Wraper::Test) }
    end
  end
end
