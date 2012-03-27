gem 'github', '>= 0.7.0', :group => [:development]

after_everything do
  if config["github_private"]
    run "bundle exec gh create-from-local --private"
  else
    run "bundle exec gh create-from-local"
  end

  # TODO - what to do if repo already exists? prompt to override?
  
  @git_uri = `git config remote.origin.url`.strip
  say_custom "github", "Created repo #{@git_uri}"
end

__END__

name: GitHub
description: Create/push project to new GitHub repository
author: drnic

category: deployment
exclusive: scm-hosting

requires: [git]
run_after: [git]

config:
  - github_private:
      type: boolean
      prompt: "Creating GitHub repository; want it to be private?"
