require 'eldarscrolls/scrolls'
require 'eldarscrolls/scroll'
require 'eldarscrolls/config'
require 'eldarscrolls/template'

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = EldarScrolls::Scroll.generate(key, File.open(path))
  EldarScrolls::Scrolls.add(scroll)
end
