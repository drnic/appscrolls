# Scroll is based on the following documentation
# * http://blog.cloudfoundry.com/2012/03/15/using-cloud-foundry-services-with-ruby-part-2-run-time-support-for-ruby-applications/
# * http://blog.cloudfoundry.com/2012/04/19/deploying-jruby-on-rails-applications-on-cloud-foundry/

vmc_version = '0.3.23'

@name = File.basename(File.expand_path("."))

gem 'vmc', "~> #{vmc_version}"
gem  'cf-runtime'

required_dbs = %w[mysql postgresql]

selected_db = required_dbs.find { |db| scroll? db }
unless selected_db
  say_custom "cf", "Please include a DB choice from: #{required_dbs.join ", "}"
  exit_now = true
end

manifest = {"applications"=>
  {"."=>
    {"name"=>@name,
     "framework"=>
      {"name"=>"rails3",
       "info"=>
        {"mem"=>"256M", "description"=>"Rails Application", "exec"=>nil}},
     "url"=>"${name}.${target-base}",
     "mem"=>"256M",
     "instances"=>1,
     "services"=>{}}}}

case selected_db.to_sym
when :postgresql
  manifest["applications"]["."]["services"]["#{@name}-postgresql"] = {"type"=>"postgresql"}
  db_username = config['pg_username'] || 'root'
  db_password = config['pg_password'] || ''
when :mysql
  manifest["applications"]["."]["services"]["#{@name}-mysql"] = {"type"=>"mysql"}
end

require "yaml"
create_file "manifest.yml", manifest.to_yaml

exit 1 if exit_now

after_bundler do
  # Desirable to vendor everything
  run "bundle package"

  production = <<-YAML.gsub(/^\s{2}/, '')
  production:
    adapter: #{selected_db}
    <% db_svc = CFRuntime::CloudApp.service_props('#{selected_db}') %>
    database: <%= db_svc[:database] rescue '#{project_name}_production' %>
    username: <%= db_svc[:username] rescue '#{db_username}' %>
    password: <%= db_svc[:password] rescue '#{db_password}' %>
    <%= db_svc && db_svc[:host] ? "host: \#{db_svc[:host]}" : "" %>
    <%= db_svc && db_svc[:port] ? "port: \#{db_svc[:port]}" : "" %>
  YAML
  append_file "config/database.yml", production
end

after_everything do
  run "rake assets:precompile"
  if jruby?
   run "warble"
    run "mkdir -p deploy"
    run "cp #{project_name}.war deploy/"
  end
  run "vmc _#{vmc_version}_ push #{project_name} --runtime ruby19 --path . --no-start"
  run "vmc _#{vmc_version}_ env-add #{project_name} BUNDLE_WITHOUT=assets:test:development"
  run "vmc _#{vmc_version}_ start #{project_name}"
end

__END__

name: Cloud Foundry
description: Prepare codebase and perform initial deploy to a Cloud Foundry target
website: http://cloudfoundry.org
author: drnic

requires: []
run_after: [postgresql, mysql]
run_before: []

category: deployment
