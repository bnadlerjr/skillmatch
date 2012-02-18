require 'rack/test'
require 'launchy'

# Base Test Case for testing Rack apps. Provides custom assertions. Relies on
# rack-test.
class Rack::TestCase < Test::Unit::TestCase
  include Rack::Test::Methods

  CONTENT_TYPES = {
    :json => "application/json;charset=utf-8",
    :html => "text/html;charset=utf-8"
  }

  # Saves the last response body as a web page.
  def show_me_the_page
    filename = File.join('tmp', "#{Time.now.strftime('%Y-%m-%d %T')}.html")
    File.open(filename, 'w') { |f| f.write(last_response.body) }
    Launchy.open(filename)
  end

  # Asserts that the last response content type matches +content_type+.
  # +content_type+ can be either +:html+ or +:json+.
  def assert_content_type(content_type)
    unless CONTENT_TYPES.keys.include?(content_type)
      raise ArgumentError, "unrecognized content_type (#{content_type})"
    end

    assert_equal CONTENT_TYPES[content_type], last_response.content_type
  end

  # Asserts that the last response code matches +status+. If it does not, and
  # +show_page+ is true, the response body is saved to a file and opened using
  # the default browser. +show_page+ is +true+ by default.
  def assert_response(status, show_page=true)
    unless last_response.send("#{status}?")
      show_me_the_page if show_page
      flunk "expected last_response to be #{status} but was #{last_response.status}"
    end
  end

  # Asserts that the last response body matches the regular expression
  # +expected+.
  def assert_body_includes(expected)
    assert last_response.body.match(expected),
      "expected last_response body to include #{expected}"
  end
end
