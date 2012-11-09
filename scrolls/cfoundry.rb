# Scroll is based on the following documentation
# * http://blog.cloudfoundry.com/2012/03/15/using-cloud-foundry-services-with-ruby-part-2-run-time-support-for-ruby-applications/
# * http://blog.cloudfoundry.com/2012/04/19/deploying-jruby-on-rails-applications-on-cloud-foundry/

gem 'vmc'
gem  'cf-runtime'

required_dbs = %w[mysql postgresql]

selected_db = required_dbs.find { |db| scroll? db }
unless selected_db
  say_custom "cfoundry", "Please include a DB choice from: #{required_dbs.join ", "}"
  exit_now = true
end

# TODO similar config for mysql
db_username = config['pg_username'] || 'root'
db_password = config['pg_password'] || ''

after_bundler do
  # Must vendor everything
  run "bundle package"

  append_file "config/database.yml" do
  <<-YAML.gsub(/^\s{2}/, '')
  production:
    adapter: #{selected_db}
    <% require 'cfruntime/properties' %>
    <% db_svc = CFRuntime::CloudApp.service_props('#{selected_db}') %>
    database: <%= db_svc[:database] rescue '#{project_name}_production' %>
    username: <%= db_svc[:username] rescue '#{db_username}' %>
    password: <%= db_svc[:password] rescue '#{db_password}' %>
    <%= db_svc && db_svc[:host] ? "host: #{db_svc[:host]}" : "" %>
    <%= db_svc && db_svc[:port] ? "post: #{db_svc[:port]}" : "" %>
  YAML
  end
end

after_everything do
  run "rake assets:precompile"
  if jruby?
   run "warble"
    run "mkdir -p deploy"
    run "cp #{project_name}.war deploy/"
  end
  run "vmc push #{project_name} --runtime ruby19 --path . --no-start"
  run "vmc env-add #{project_name} BUNDLE_WITHOUT=assets:test:development"
  run "vmc start #{project_name}"
end

__END__

name: CloudFoundry
description: Prepare codebase and perform initial deploy to a CloudFoundry target
website: http://cloudfoundry.org
author: drnic

requires: []
run_after: [postgresql, mysql]
run_before: []

category: deployment
# exclusive:

# config:
#   - foo:
#       type: boolean
#       prompt: "Is foo true?"
