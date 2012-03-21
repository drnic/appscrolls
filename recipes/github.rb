gem 'github', '>= 0.7.0', :group => [:development]

after_everything do
  if config["private"]
    run "bundle exec gh create-from-local --private"
  else
    run "bundle exec gh create-from-local"
  end
  say_custom "github", "Created repo #{`git config remote.origin.url`}"
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
  - private:
      type: boolean
      prompt: "Creating GitHub repository; want it to be private?"
