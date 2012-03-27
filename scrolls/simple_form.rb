gem 'simple_form'

after_bundler do
  if scroll? "twitter_bootstrap_rails"
    generate "simple_form:install --bootstrap"
  else
    generate "simple_form:install"
  end
end

__END__

name: Simple Form
description: Install Simple Form to generate nicely formatted forms.
author: jonochang

exclusive: forms 
category: other
tags: [forms]
