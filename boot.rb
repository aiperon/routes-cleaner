require 'bundler'

Bundler.require(:default, ENV['APP_ENV'] || '')

Dir.glob('./lib/**/*.rb'){|file| require file }