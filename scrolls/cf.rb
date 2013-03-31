# Scroll is based on the following documentation
# * http://blog.cloudfoundry.com/2012/03/15/using-cloud-foundry-services-with-ruby-part-2-run-time-support-for-ruby-applications/
# * http://blog.cloudfoundry.com/2012/04/19/deploying-jruby-on-rails-applications-on-cloud-foundry/

require "yaml"

@vmc_version = '0.3.23'
@name = File.basename(File.expand_path("."))
@cf_ruby_runtime = "ruby19" # might change later in scrolls

gem 'vmc', "~> #{@vmc_version}"
gem  'cf-runtime'

known_services = %w[postgresql mysql redis mongodb]
required_dbs = %w[mysql postgresql]

selected_db = required_dbs.find { |db| scroll? db }
unless selected_db
  say_custom "cf", "Please include a DB choice from: #{required_dbs.join ", "}"
  exit_now = true
end

$cf_manifest = {"applications"=>
  {"."=>
    {"name"=>@name,
     "framework"=>
      {"name"=>"rails3",
       "info"=>
        {"mem"=>"256M", "description"=>"Rails Application", "exec"=>nil}},
     "url"=>"${name}.${target-base}",
     "runtime"=>@cf_ruby_runtime,
     "mem"=>"256M",
     "instances"=>1,
     "services"=>{}}}}

known_services.each do |service|
  if scroll? service
    $cf_manifest["applications"]["."]["services"]["#{@name}-#{service}"] = {"type"=>service}
  end
end

db_username = config['pg_username'] || 'root'
db_password = config['pg_password'] || ''

exit 1 if exit_now

after_bundler do
  cf_delete_app @name

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
  create_file "manifest.yml", $cf_manifest.to_yaml

  run "rake assets:precompile"
  if jruby?
   run "warble"
    run "mkdir -p deploy"
    run "cp #{project_name}.war deploy/"
  end
  run "vmc _#{@vmc_version}_ push #{project_name} --runtime #{@cf_ruby_runtime} --path . --no-start"
  run "vmc _#{@vmc_version}_ env-add #{project_name} BUNDLE_WITHOUT=assets:test:development"
  run "vmc _#{@vmc_version}_ start #{project_name}"
end

def cf_delete_app(name)
  run %Q{vmc _#{@vmc_version}_ apps | grep "\\b#{name}\\b" && vmc _#{@vmc_version}_ delete #{name}}
end

def cf_standalone_command(key, name, command, services={})
  cf_manifest = {"applications"=>
    {"."=>
      {"name"=>name,
       "framework"=>
        {"name"=>"standalone",
         "info"=>
          {"mem"=>"64M", "description"=>"Standalone Application", "exec"=>nil}},
       "url"=>nil,
       "runtime"=>@cf_ruby_runtime,
       "command"=>command,
       "mem"=>"256M",
       "instances"=>1,
       "services"=>services}}}
  create_file "manifest.#{key}.yml", cf_manifest.to_yaml
  "manifest.#{key}.yml"
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
