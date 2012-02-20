require 'rubygems'
require 'bundler'
Bundler.setup

$:.push File.dirname(__FILE__)

require 'sinatra/base'
require 'json'
require 'linkedin'
require 'skillmatch/linkedin_helper'
require 'skillmatch/skill_processor'
