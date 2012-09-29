# Override bundle install command to ensure that everything goes
# into our rvm gemset
@bundle_install_command = "bundle install"

before_everything do
  # Create gemset and create .rvmrc
  ruby_version = config['ruby_version']
  rvm_env = "#{ruby_version}@#{@app_name}"
  run "bash -c 'source $HOME/.rvm/scripts/rvm; rvm use #{rvm_env} --create; rvm --rvmrc --create use #{rvm_env}'"

  # Add directive for ruby version to Gemfile
  insert_into_file "Gemfile", "ruby '#{ruby_version.gsub /-.*/, ''}'\n", :after => "source 'https://rubygems.org'\n\n"

  # Load RVM environment so future shell commands, such as generators, work
  File.open("#{ENV['HOME']}/.rvm/environments/ruby-#{rvm_env}", 'r').each_line do |line|
    # Lines in the rvm environment file look like this: export RUBY_VERSION ; RUBY_VERSION='ruby-1.9.3-p194'
    if line =~ /^.+\s;\s(.+)=(\"|\')(.+)(\"|\')$/
      ENV[$1] = $3.gsub "$PATH", ENV['PATH']
    end
  end
end

__END__

name: rvm
description: setup project-specific gemset and version of ruby using RVM
website: https://rvm.io/
author: mattolson

category: deployment

config:
  - ruby_version:
      type: string
      prompt: "Which version of ruby do you want? (Must be already installed and registered with RVM. i.e '1.9.3-p194')"
