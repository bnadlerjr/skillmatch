require File.join(File.dirname(__FILE__), 'lib/skillmatch/server')
require 'sprockets'

map '/assets' do
  env = Sprockets::Environment.new
  env.append_path 'lib/skillmatch/assets/javascripts'
  env.append_path 'lib/skillmatch/assets/stylesheets'
  env.append_path 'lib/skillmatch/assets/images'
  run env
end

map '/' do
  run Skillmatch::Server
end
