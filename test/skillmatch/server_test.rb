require 'test_helper'
require 'rack_test_case'
require 'skillmatch/server'

module Skillmatch
  class ServerTest < Rack::TestCase
    test 'get root' do
      get '/'
      assert_response :ok
      assert_content_type :html
      assert_body_includes('Index template')
    end

    private
      def app
        Skillmatch::Server
      end
  end
end
