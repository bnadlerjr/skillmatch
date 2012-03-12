require 'rubygems'
require 'bundler'
Bundler.setup

$:.push File.dirname(__FILE__)

require 'sinatra/base'
require 'json'
require 'sinatra-linkedin'
require 'skillmatch/skill_processor'
