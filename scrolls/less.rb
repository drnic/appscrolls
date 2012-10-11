# We'd rather manipulate the default Gemfile than add new entries
# or duplicate groups
before_everything do
  uncomment_lines 'Gemfile', "gem 'therubyracer'"
  insert_into_file 'Gemfile', "  gem 'less-rails'\n", :after => /gem 'therubyracer'.*\n/
end

after_bundler do
  insert_into_application_config <<-CONFIG
    # Use LESS as default for generators
    #config.app_generators.stylesheet_engine :less # doesn't seem to have any effect
    config.sass.preferred_syntax = :less
  CONFIG
end

__END__

name: Less
description: Use less instead of sass as default stylesheet preprocessor
website: https://github.com/metaskills/less-rails
author: mattolson
category: css
requires: [yui_compressor]
