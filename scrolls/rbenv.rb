run "rbenv local #{config['ruby_version']}"
insert_into_file "Gemfile", "ruby '#{config['ruby_version'].gsub /-.*/, ''}'\n", :after => "source 'https://rubygems.org'\n"

__END__

name: rbenv
description: set project-specific ruby version using rbenv
website: https://github.com/sstephenson/rbenv
author: mattolson

category: development

config:
  - ruby_version:
      type: string
      prompt: "Which version of ruby do you want? (Must be already installed and registered in rbenv. i.e '1.9.3-p194')"
