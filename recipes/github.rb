gem 'github'

after_everything do
  if config["private"]
    run "gh create-from-local --private"
  else
    run "gh create-from-local"
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
      prompt: "Create private GitHub repository?"
