gem 'jenkins'

after_everything do
  public_repo = !config["github_private"]
  run "jenkins create . --scm #{@git_uri}#{' --public-scm' unless public_repo} --template rails3"

  if scrolls?("github")
    # TODO add github post-commit hook to jenkins build
  end
end

__END__

name: Jenkins
description:
author: drnic
website:

requires: [github]
run_after: [github]

category: testing
exclusive: ci

config:
  - jenkins_host:
      type: string
      prompt: "Jenkins CI host?"
