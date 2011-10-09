gem 'devise_invitable'

after_bundler do
  generate 'devise_invitable:install'
  generate 'devise_invitable user'
end

after_everything do
  generate 'devise_invitable:views users'
end

__END__

name: Devise Invitable
description: Utilize Devise Invitable to allow users to invite other users to sign up to the system
author: jonochang

category: authentication
exclusive: authentication
run_after: [devise]

config:
  - generate_user_scoped_view:
      type: boolean
      prompt: "Generate Devise Invitable user scoped views?"

