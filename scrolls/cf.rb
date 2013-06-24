# Scroll is based on the following documentation
# * http://blog.cloudfoundry.com/2012/03/15/using-cloud-foundry-services-with-ruby-part-2-run-time-support-for-ruby-applications/
# * http://blog.cloudfoundry.com/2012/04/19/deploying-jruby-on-rails-applications-on-cloud-foundry/

require "yaml"

@name = File.basename(File.expand_path("."))

# TODO set ruby for buildpack in Gemfile
@cf_ruby_runtime = "2.0.0" # might change later in scroll
gsub_file "Gemfile", %r{source 'http://rubygems.org'}, <<-EOS
source 'http://rubygems.org'

ruby '#{@cf_ruby_runtime}'
EOS

gem 'cf'
gem 'cf-runtime'

known_services = %w[postgresql mysql redis mongodb]
@service_labels = known_services.select { |service| scroll? service }
if scroll? 'postgresql'
  selected_sql = 'postgresql'
elsif scroll? 'mysql'
  selected_sql = 'mysql'
end

def run_cf(*command)
  run "cf #{command.join(' ')}"
end

def cf_delete_app(name)
  run %Q{cf apps | grep "^#{name} " && cf delete #{name}}
end

# Adds the following
# applications:
# - name: NAME
#   memory: 256M
#   instances: 1
#   url: NAME.${target-base}
#   path: .
#   services:
#     postgresql-NAME:
#       label: postgresql
#       provider: core
#       version: '9.2'
#       plan: default
def cf_web_app(name, service_labels=[])
  services = {}
  if service_labels.include?("postgresql")
    services["postgresql-#{name}"] = {
      "label" => "postgresql",
      "provider" => "core",
      "version" => "9.2",
      "plan" => "default"
    }
  end
  { 
    "name" => name,
    "memory" => "256M",
    "instances" => 1,
    "url" => "#{name}.${target-base}",
    "path" => ".",
    "services" => services
  }
end

$cf_manifest = {"applications"=>[]}
$cf_manifest["applications"] << cf_web_app(@name, @service_labels)

db_username = config['pg_username'] || 'root'
db_password = config['pg_password'] || ''

after_bundler do
  cf_delete_app @name

  # Desirable to vendor everything
  run "bundle package"

  production = <<-YAML.gsub(/^\s{2}/, '')
  production:
    adapter: #{selected_sql}
    <% db_svc = CFRuntime::CloudApp.service_props('#{selected_sql}') %>
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
  run_cf "push"
end


__END__

name: Cloud Foundry v2
description: Prepare codebase and perform initial deploy to a Cloud Foundry target
website: http://cloudfoundry.org
author: drnic

requires: []
run_after: [postgresql, mysql]
run_before: []

category: deployment
