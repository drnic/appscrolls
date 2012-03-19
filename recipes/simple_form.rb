if config['use_edge']
  gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git'
else
  gem 'simple_form'
end

after_bundler do
  generate "simple_form:install"
end

__END__

name: Simple Form
description: Install Simple Form to generate nicely formatted forms.
author: jonochang

exclusive: forms 
category: forms
tags: [forms]

config:
  - use_edge:
      type: boolean
      prompt: "Using Edge version of Simple Form?"

