require 'eldarscrolls/scrolls'
require 'eldarscrolls/scroll'
require 'eldarscrolls/config'
require 'eldarscrolls/template'

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = Eldar::Scroll.generate(key, File.open(path))
  Eldar::Scrolls.add(scroll)
end
