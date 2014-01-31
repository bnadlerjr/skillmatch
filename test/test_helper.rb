$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'         # Don't report on test files
  coverage_dir 'tmp/coverage' # Put results in /tmp folder
end

require 'test/unit'
require 'contest'
require 'mocha/setup'
