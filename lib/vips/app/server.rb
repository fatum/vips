require 'json'
require 'sinatra'
require 'sprockets'

class Server < Sinatra::Base
  enable :inline_templates

  helpers do
    def save_structure_like_fixture!(page, structure)
      page_hash = Digest::MD5.hexdigest(page)
      file_path = File.expand_path("../../../../spec/fixtures/#{page_hash}.dump", __FILE__)
      File.delete file_path if File.exists? file_path
      File.open(file_path, 'w') do |f|
        f.write JSON.dump(structure)
      end
    end

    def prepare_result(root_block)
      aggregate root_block, []
    end

    def aggregate(block, response)
      response << block.xpath
      block.children.each { |child| aggregate(child, response) }
      response
    end

    def prepare(dom)
      if dom["children"]
        dom["children"] = dom["children"].values.map { |child| prepare(child) }
      end
      dom
    end
  end

  post '/serialize' do
    if params[:dom]
      dom = prepare params[:dom]
      puts dom.inspect
      save_structure_like_fixture! params[:url], dom
    end

    {status: :ok, blocks: []}.to_json

  end

  post "/extract" do
    if params[:dom]
      dom = prepare params[:dom]
      extractor = Vips::Extractor.new(dom)
      blocks = prepare_result extractor.extract_blocks!
    end

    {status: :ok, blocks: blocks}.to_json
  end

  get '/' do
  end

  get "/test" do
    haml :index
  end
end

__END__
@@ layout
!!!
%html
  %head
    %title VIPS bookmark tests
    %script{src:"http://localhost:9393/assets/application.js"}
  %body
    = yield

@@ index
.container
  .bookmark
    %a{href: "javascript:function iprl5(){var d=document,z=d.createElement('scr'+'ipt'),b=d.body,l=d.location;try{if(!b)throw(0);d.title='(Saving...) '+d.title;z.setAttribute('src',l.protocol+'//localhost:9393/assets/application.js?u='+encodeURIComponent(l.href)+'&t='+(new Date().getTime()));b.appendChild(z);}catch(e){alert('Please wait until the page has loaded.');}}iprl5();void(0)"} Bookmarklet
  .header
  .menu
  .footer


