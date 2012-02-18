require File.join(File.dirname(__FILE__), '../skillmatch')

module Skillmatch
  # The main application server.
  class Server < Sinatra::Base
    set :app_file, __FILE__
    set :public_folder, Proc.new { File.join(root, '../public') }

    get '/' do
      haml :index
    end
  end
end
