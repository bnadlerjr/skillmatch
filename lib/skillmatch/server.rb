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

    include Skillmatch::SkillProcessor

    get '/' do
      haml :index
    end

    get '/search' do
      content_type :json
      connections = client.connections(
        :fields => %w(id first-name last-name skills))["all"]

      match_skill_for(params[:term], connections).to_json
    end

    get '/auth' do
      request_token = client.request_token(:oauth_callback =>
        "http://#{request.host}:#{request.port}/auth/callback")

      session[:rtoken]  = request_token.token
      session[:rsecret] = request_token.secret

      redirect client.request_token.authorize_url
    end

    get '/auth/callback' do
      if session[:atoken].nil?
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
