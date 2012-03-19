
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

  run 'rails plugin install git://github.com/parolkar/pfeed.git'

  run 'rake pfeed:setup'
end

__END__

name: Pfeed
description: "Plugin to create a user's activity feed"
author: jonochang

category: other

# does not support rails 3.1+ https://github.com/parolkar/pfeed/issues/18