require 'test_helper'
require 'rack_test_case'
require 'skillmatch/server'

module Skillmatch
  class ServerTest < Rack::TestCase
    setup do
      app.send(:set, :sessions, false)
    end

    test 'get root' do
      get '/'

      assert_response :ok
      assert_content_type :html
      assert_body_includes('Skillmatch')
    end

    test 'get connections with skills that match search term' do
      client = mock('LinkedIn::Client')
      client.expects(:connections)
        .with(:fields => %w(id first-name last-name skills))
        .returns({"all" => [
          {"first_name"=>"Jim",
           "id"=>"oRtv",
           "last_name"=>"Beam",
           "skills"=>
            {"total"=>1, "all"=>[{"id"=>1, "skill"=>{"name"=>"Ruby"}}]}
          }
        ]})

      LinkedIn::Client.stubs(:new).returns(client)

      expected = '[{"first_name":"Jim","id":"oRtv","last_name":"Beam",' +
        '"skills":{"total":1,"all":[{"id":1,"skill":{"name":"Ruby"}}]},' +
        '"similarity":1.0}]'

      get '/search?term=ruby'

      assert_response :ok
      assert_content_type :json
      assert_equal expected, last_response.body
    end

    test 'authenticate' do
      request_token = mock('OAuth::RequestToken',
        :token         => 'my_token',
        :secret        => 'my_secret',
        :authorize_url => 'http://example.com/authorize_url'
      )

      client = mock('LinkedIn::Client')
      client.stubs(:request_token).returns(request_token)

      LinkedIn::Client.stubs(:new).returns(client)

      get '/auth'

      assert_response :redirect
      assert_equal 'http://example.com/authorize_url', last_response.location
      assert_session :rtoken, 'my_token'
      assert_session :rsecret, 'my_secret'
    end

    test "authentication callback without existing access token" do
      client = mock('LinkedIn::Client')
      client.expects(:authorize_from_request)
        .with('some rtoken', 'some rsecret', 'some pin')
        .returns(['access token', 'access secret'])

      LinkedIn::Client.stubs(:new).returns(client)

      set_session(:rtoken => 'some rtoken', :rsecret => 'some rsecret')

      get '/auth/callback', { :oauth_verifier => 'some pin' }, env

      assert_response :redirect
      assert_equal 'http://example.org/', last_response.location
      assert_session :atoken, 'access token'
      assert_session :asecret, 'access secret'
    end

    test "authentication callback with existing access token" do
      set_session :rtoken => 'some rtoken',
        :rsecret => 'some rsecret', :atoken => 'access token'

      get '/auth/callback', { :oauth_verifier => 'some pin' }, env

      assert_response :redirect
      assert_equal 'http://example.org/', last_response.location
      assert_session :atoken, 'access token'
    end

    test "logout" do
      set_session(:rtoken => 'request token', :atoken => 'access token')

      get '/auth/logout', {}, env

      assert_response :redirect
      assert_equal 'http://example.org/', last_response.location
      assert_session :rtoken, nil
      assert_session :atoken, nil
    end

    private
      def app
        Skillmatch::Server
      end

      def set_session(session_hash)
        env['rack.session'] = session_hash
      end

      def env
        @env ||= {}
      end
  end
end
