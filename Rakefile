#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'coffee-script'
require 'sprockets'

namespace :chrome do
  desc "Compile chrome plugin"
  task :compile do
    environment = Sprockets::Environment.new
    environment.append_path 'lib/vips/app/assets/javascripts'

    js = environment['application.js']

    path = "#{File.dirname(__FILE__)}/chromeplugin/vips_dom.js"
    open path, 'w' do |f|
      f.puts js
    end
  end
end

namespace :js do
  desc "compile coffee-scripts from ./src to ./public/javascripts"
  task :compile do
    source = "#{File.dirname(__FILE__)}/src/"
    javascripts = "#{File.dirname(__FILE__)}/public/javascripts/"

    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..'
        js = CoffeeScript.compile File.read("#{source}#{cf}")
        open "#{javascripts}#{cf.gsub('.coffee', '.js')}", 'w' do |f|
          f.puts js
        end
      end
    end
  end
end
