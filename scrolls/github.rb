gem 'github', '>= 0.7.0', :require => nil, :group => [:development]

after_everything do
  tried_create_already = false
  while (@git_uri = `git config remote.origin.url`.strip) && @git_uri.size == 0
    if tried_create_already
      @repo_name = ask_wizard "Repository already exists. What project name?"
    else
      @repo_name = ""
    end
    if config["github_private"]
      run "bundle exec gh create-from-local #{@repo_name} --private"
    else
      run "bundle exec gh create-from-local #{@repo_name}"
    end
    tried_create_already = true
  end
  
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
      prompt: "Create a GitHub repository?"
      type: multiple_choice
      choices: [["Public", false], ["Private", true]]
