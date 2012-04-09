require 'appscrolls/scrolls'
require 'appscrolls/scroll'
require 'appscrolls/config'
require 'appscrolls/template'

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = AppScrollsScrolls::Scroll.generate(key, File.open(path))
  AppScrollsScrolls::Scrolls.add(scroll)
end
