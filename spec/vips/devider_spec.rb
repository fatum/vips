require 'spec_helper'

describe Vips::Divider do
  let(:dom) do
    driver = Watir::Browser.new :firefox
    Headless.ly do
      driver.goto 'http://amazon.com'
    end
    driver
  end

  describe "#get_result" do
    context "when empty signals list" do
      subject { described_class.new(dom.elements, []) }

      its(:get_result) { should be_instance_of(Vips::Pool) }
    end
  end
end
