require 'nokogiri'
require 'css_parser'

module Vips
  module Wraper
    class Nokogiri
      attr_reader :html, :css

      def goto(url)
        @html = Nokogiri::HTML RestClient.get(url)
        @css = CssParser.new

        download_css
        setup
      end

      def quit
      end

      private
      def setup
        body = html.at_css('body')
        root = create_element(body)

        setup_children_for root

        root
      end

      def download_css
        html.css('link[rel="stylesheet"]').each { |style| css.load_uri!(style) }
      end

      def setup_children_for(el)
        el.children.each do |child|
          el.add_child create_element(child, el)
        end
      end

      def create_element(element, parent = nil)
        dom = Dom::Element.new(
          tag_name: element.name,
          text: element.content,
          parent: parent,
          width: get_width,
          height: get_height
        )

        setup_children_for dom
        dom
      end

      def get_width

      end

      def get_height
      end
    end
  end
end
