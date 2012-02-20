require 'rubygems'
require 'bundler'
Bundler.setup

$:.push File.dirname(__FILE__)

require 'sinatra/base'
require 'linkedin'
require 'skillmatch/linkedin_helper'
