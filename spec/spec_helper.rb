require 'bundler'
Bundler.setup
require 'rspec'

Dir[File.dirname(__FILE__) + '/support/*'].each{|path| require path}

require 'eldarscrolls'

RSpec.configure do |config|

end
