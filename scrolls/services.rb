# Setup hooks to add service control rake tasks.
# See the postgresql scroll for an example of how to use this.
rakefile 'services.rake' do
  <<-RAKE
module ServiceHelper
  SERVICE_SPECS = {
  }

  def service_status(service_name)
    retval = :unknown
    pidfile = SERVICE_SPECS[service_name][:pidfile]

    if File.exists?(pidfile)
      process_id = File.open(pidfile) {|f| f.readline}
      ps_output = `ps -p \#{process_id} &> /dev/null`
      if $?.exitstatus == 0
        puts "\#{service_name} running; pid = \#{process_id}"
        retval = :running
      else
        puts "not running; stale pid = \#{process_id}"
        retval = :not_running
      end
    else
      puts "not running"
      retval = :not_running
    end

    retval
  end
end

include ServiceHelper

namespace :services do
  SERVICE_SPECS.keys.each do |s|
    namespace s do
      desc "Get status of \#{s} service"
      task :status => :environment do
        service_status s
      end

      desc "Start \#{s}"
      task :start => :environment do
        next unless service_status(s) == :not_running
        system SERVICE_SPECS[s][:start]
      end

      desc "Stop \#{s}"
      task :stop => :environment do
        next unless service_status(s) == :running
        system SERVICE_SPECS[s][:stop]
      end
    end
  end
end
  RAKE
end

__END__

name: Services
description: Setup service rake tasks and allow other scrolls to plug into it
author: mattolson

category: development

