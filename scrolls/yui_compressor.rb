# Replace default uglifier with yui-compressor
before_everything do
  gsub_file 'Gemfile', /gem 'uglifier'.*\n/, "gem 'yui-compressor'\n"
end

after_bundler do
  insert_into_application_config <<-CONFIG
    # Use YUI compressor
    config.assets.css_compressor = :yui
    config.assets.js_compressor = :yui
  CONFIG
end

__END__

name: YUI Compressor
description: Use yui-compressor gem for css and js asset compression
website: http://developer.yahoo.com/yui/compressor/
author: mattolson
category: deployment
