require 'appscrolls/scrolls'
require 'appscrolls/scroll'
require 'appscrolls/config'
require 'appscrolls/template'

Gem.path.each do |gemdir|
  Dir[gemdir + '/gems/*/scrolls/*.rb'].each do |path|
    key = File.basename(path, '.rb')
    scroll = AppScrollsScrolls::Scroll.generate(key, File.open(path))
    AppScrollsScrolls::Scrolls.add(scroll)
  end
end

Dir[File.expand_path("~/.scrolls") + '/**/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = AppScrollsScrolls::Scroll.generate(key, File.open(path))
  AppScrollsScrolls::Scrolls.add(scroll)
end
