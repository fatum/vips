shared_context :divider_base do
end

shared_context :divider_body do
  let(:body) do
     e = double(:element,
                xpath: 'body',
                tag_name: "body",
                text_node?: false,
                children: children,
                width: 1024, height: 768,
                top: 0, left: 0,
                offset_left: 1024, offset_top: 768,
                color: :black,
                visible?: true
               )
    Vips::Block::Element.new(e)
  end

  let(:children) do
    3.times.map do |i|
     double("block_element_#{i}",
                tag_name: "p",
                text_node?: true,
                children: children2,
                width: 1024, height: 50,
                left: 0, top: 10 * i,
                offset_left: 1024, offset_top: 50 + 10*i,
                color: :white,
                xpath: "body/p[#{i}]",
                visible?: true
               )
    end
  end

  let(:children2) do
    3.times.map do |i|
     double("block_children_element_#{i}",
                tag_name: "div",
                text_node?: true,
                children: [],
                width: 100, height: 50,
                left: 40, top: 10 * i,
                offset_left: 140, offset_top: 10 + 10*i,
                color: :white,
                xpath: "body/p[#{i}]/div[#{i}]",
                visible?: true
               )
    end
  end
end
