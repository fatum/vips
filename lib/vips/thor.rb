require 'thor'
require 'vips'

module Vips
  class Thor < ::Thor
    desc 'extract URL', "Set url for block's extraction"
    def extract(url)
      blocks = Vips::Extractor.extract_blocks(url)
      puts blocks.inspect
    end
  end
end
