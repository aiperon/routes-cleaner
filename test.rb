ENV['APP_ENV'] = 'test'

require './boot'

Dir.glob('./test/**/*_test.rb') do |file|
  require file
end