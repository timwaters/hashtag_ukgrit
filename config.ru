# This file goes in domain.com/config.ru
require 'vendor/rack/lib/rack.rb'
require 'vendor/sinatra/lib/sinatra.rb'

require 'rubygems'
require 'rfeedparser'
ENV['GEM_PATH']  = File.expand_path('~/.gems')
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

require 'rash.rb'

map '/' do
run Sinatra.application
end

map '/ukgrit/' do
run Sinatra.application
end
map '/ukgrit' do

run Sinatra.application
end
