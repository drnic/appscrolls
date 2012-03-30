gem 'jenkins'

after_everything do
  public_repo = !config["github_private"]
  run "jenkins create . --scm #{@git_uri}#{' --public-scm' unless public_repo} --template rails3"
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
