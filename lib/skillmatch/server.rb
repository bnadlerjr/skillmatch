require File.join(File.dirname(__FILE__), '../skillmatch')

module Skillmatch
  # The main application server.
  class Server < Sinatra::Base
    set :app_file, __FILE__
    set :public_folder, Proc.new { File.join(root, '../public') }

    set :linkedin_api_key, ENV['LINKEDIN_API_KEY']
    set :linkedin_api_secret, ENV['LINKEDIN_API_SECRET']

    helpers Skillmatch::LinkedInHelper

    enable :sessions

    get '/' do
      haml :index
    end

    get '/auth' do
      client = LinkedIn::Client.new(settings.linkedin_api_key, settings.linkedin_api_secret)

      request_token = client.request_token(:oauth_callback =>
        "http://#{request.host}:#{request.port}/auth/callback")

      session[:rtoken]  = request_token.token
      session[:rsecret] = request_token.secret

      redirect client.request_token.authorize_url
    end

    get '/auth/callback' do
      if session[:atoken].nil?
        client = LinkedIn::Client.new(settings.linkedin_api_key, settings.linkedin_api_secret)
        pin = params[:oauth_verifier]
        session[:atoken], session[:asecret] =
          client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      end

      redirect '/'
    end

    get '/auth/logout' do
      session[:rtoken] = nil
      session[:atoken] = nil
      redirect '/'
    end
  end
end
