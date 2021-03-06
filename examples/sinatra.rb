require 'sinatra'

get '/' do
  @name = params[:name] || 'world'
  erb :index
end

__END__
@@ Gemfile
source 'https://rubygems.org'

gem 'sinatra'
@@ Gemfile.lock
GEM
  remote: https://rubygems.org/
  specs:
    rack (1.5.2)
    rack-protection (1.5.1)
      rack
    sinatra (1.4.4)
      rack (~> 1.4)
      rack-protection (~> 1.4)
      tilt (~> 1.3, >= 1.3.4)
    tilt (1.4.1)

PLATFORMS
  ruby

DEPENDENCIES
  sinatra
@@ index
Hello, <%= @name %>!
