module Skillmatch
  module LinkedInHelper
    def authorized?
      session[:atoken].nil? ? false : true
    end

    def authorize!
      redirect '/auth' unless authorized?
    end
  end
end
