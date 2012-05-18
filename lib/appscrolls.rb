require 'appscrolls/scrolls'
require 'appscrolls/scroll'
require 'appscrolls/config'
require 'appscrolls/template'

def enroll_scroll_at(path)
  key = File.basename(path, '.rb')
  scroll = AppScrollsScrolls::Scroll.generate(key, File.open(path))
  AppScrollsScrolls::Scrolls.add(scroll)
end

# set up local scrolls if available
if dir = ENV['APPSCROLLS_DIR'] and dir != ""
  Dir[dir + '/*.rb'].each do |path|
    enroll_scroll_at(path)
  end
end

# default files of same keys as local scrolls are discarded
Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  enroll_scroll_at(path)
end
