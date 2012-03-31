gem "prototype-rails"

after_bundler do
  gsub_file "app/assets/javascripts/application.js", "//= require prototype_ujs", <<-EOS
//= require prototype_ujs
//= require effects
//= require dragdrop
//= require controls
EOS
end

__END__

name: Prototype
description: "Prototype.JS as the JavaScript framework"
author: mbleigh

exclusive: javascript_framework
category: assets

args: -j prototype