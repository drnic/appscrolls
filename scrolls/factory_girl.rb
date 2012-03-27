gem 'factory_girl', :group => [:development, :test]
gem 'factory_girl_rails', :group => [:development, :test]

after_bundler do
  File.open('spec/factories.rb', 'w') {|f| f.write("FactoryGirl.define do
end")}

  factory_user = <<-RB
FactoryGirl.define do
  factory :user do
    factory_password = Forgery(:basic).password
    email { Forgery(:internet).email_address }
    password factory_password
    password_confirmation factory_password
  end
  
RB
  if config['use_devise']
    gsub_file 'spec/factories.rb', 'FactoryGirl.define do', factory_user
  end
end

__END__

name: Factory Girl
description: "Use Factory Girl to replace fixtures"
author: jonochang

exclusive: fixtures
category: testing
tags: [fixtures, testing]

config:
  - use_devise:
      type: boolean
      prompt: "Add factory for devise user?"
      if_scroll: devise

