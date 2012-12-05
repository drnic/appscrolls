if `which hub`.strip == ""
  say_custom "hub", "Please install hub. https://github.com/defunkt/hub"
  exit 1
end

after_everything do
  github_private = multiple_choice "Create a GitHub repository?", [["Public", false], ["Private", true]]
  
  # Usage: hub create [NAME] [-p] [-d DESCRIPTION] [-h HOMEPAGE]
  
  tried_create_already = false
  while (@git_uri = `git config remote.origin.url`.strip) && @git_uri.size == 0
    if tried_create_already
      @repo_name = ask_wizard "Repository already exists. What project name?"
    else
      @repo_name = File.basename(File.expand_path("."))
    end
    if github_private
      run "hub create #{@repo_name} -p"
    else
      run "hub create #{@repo_name}w"
    end
    tried_create_already = true
  end
  run "git push origin master"
  
  say_custom "github", "Created repo #{@git_uri}"
end

__END__

name: GitHub
description: Push project to new GitHub repository
author: drnic

category: deployment
exclusive: scm-hosting

requires: [git]
run_after: [git]
