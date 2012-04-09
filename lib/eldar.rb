require 'eldar/scrolls'
require 'eldar/scroll'
require 'eldar/config'
require 'eldar/template'

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = Eldar::Scroll.generate(key, File.open(path))
  Eldar::Scrolls.add(scroll)
end
