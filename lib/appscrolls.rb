require 'appscrolls/scrolls'
require 'appscrolls/scroll'
require 'appscrolls/config'
require 'appscrolls/template'

def enroll_scroll_at(path)
  key = File.basename(path, '.rb')
  scroll_class_name = ActiveSupport::Inflector.camelize(key.gsub("-", "_"))

  # default files of same keys as local scrolls are discarded
  return if AppScrollsScrolls::Scrolls.const_defined?(scroll_class_name)

  scroll = AppScrollsScrolls::Scroll.generate(key, File.open(path))
  AppScrollsScrolls::Scrolls.add(scroll)
end

scroll_files = Dir[File.dirname(__FILE__) + '/../scrolls/*.rb']

# set up local scrolls if available
if dir = ENV['APPSCROLLS_DIR'] and dir != ""
  scroll_files = Dir[dir+"/**{,/*/**}/*.rb"] + scroll_files
end

scroll_files.each do |path|
  enroll_scroll_at(path)
end
