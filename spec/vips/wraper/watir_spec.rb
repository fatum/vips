require 'spec_helper'

describe Vips::Wraper::Watir do
  after { browser.quit }

  describe "#goto" do
    let(:browser) { described_class.new(:firefox) }

    subject { browser.goto('http://google.com') }

    it { should be_instance_of(Vips::Dom::WatirElement) }

    its(:children) { should be_instance_of(Array) }
  end
end
