after_bundler do
  
  #fixes missing Command error when running rails plugin
  if File.open('script/rails').grep(/module Commands; end/) == []
    source_rails = <<-RB
APP_PATH = File.expand_path('../../config/application',  __FILE__)
RB

    add_commands = <<-RB
module Commands; end
APP_PATH = File.expand_path('../../config/application',  __FILE__)
RB
  
    gsub_file 'script/rails', source_rails, add_commands
  end

  run 'rails plugin install git://github.com/jonochang/cartographer.git'

  if File.open('config/environment.rb').grep(/CARTOGRAPHER_GMAP_VERSION/) == []
    source = "require File.expand_path('../application', __FILE__)"
    add_cartographer_const = "require File.expand_path('../application', __FILE__)\n\nCARTOGRAPHER_GMAP_VERSION = 3"
    gsub_file 'config/environment.rb', source, add_cartographer_const
  end
end

__END__

name: pFeed
description: "Plugin to create a user's activity feed"
author: jonochang

category: social-networking
exclusive: social-networking

