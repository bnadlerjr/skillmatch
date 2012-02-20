module Skillmatch
  module LinkedInHelper
    def authorized?
      session[:atoken].nil? ? false : true
    end

    def authorize!
      redirect '/auth' unless authorized?
    end

    def client
      @client ||= LinkedIn::Client.new(settings.linkedin_api_key, settings.linkedin_api_secret)
    end
  end
end
