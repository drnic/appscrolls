# run "rvm use 1.9.3 exec rvm gemset create #{config['gemset']}"

create_file '.rvmrc', <<-END
rvm use 1.9.3@#{config['gemset']}
#{"git status -sb" if scrolls.include?('git') }
END

# run "rvm 1.9.3 do gem install bundler --pre"

run 'rvm rvmrc trust .'

__END__
name: RVM
description: Creates .rvmrc file and gemset
category: other
config:
  - gemset:
      prompt: "Specify gemset for RVM file:"
      type: string
