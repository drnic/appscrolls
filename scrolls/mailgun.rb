after_bundler do
  create_file 'config/mailer.yml', <<-END
:address: 'smtp.mailgun.org'
:port: 587
:authentication: :plain
:user_name: ''
:password: ''
:domain: ''
END

  append_file ".gitignore", "\nconfig/mailer.yml"

  inject_into_file 'config/application.rb', :after => "class Application < Rails::Application" do
<<-END

    config.action_mailer.smtp_settings = YAML.load(File.open("\#{Rails.root}/config/mailer.yml")) unless Rails.env.production?
    config.action_mailer.default_url_options = { :host => 'localhost', :port => 3000 }
    routes.default_url_options = { :host => 'localhost', :port => 3000 }
END
  end

  inject_into_file 'config/environments/production.rb', :after => "Application.configure do" do
<<-END

  routes.default_url_options = { :host => '#{app_name}.com' }
  config.action_mailer.smtp_settings = {
      :authentication => :plain,
      :address => "smtp.mailgun.org",
      :port => 587,
      :domain => ENV["MAILGUN_DOMAIN"],
      :user_name => ENV["MAILGUN_USERNAME"],
      :password => ENV["MAILGUN_PASSWORD"]}
END
  end

  generate "mailer notifier"

  inject_into_file 'app/mailers/notifier.rb', :before => "\nend" do
<<-END

  def simple(params)
    mail params
  end
  
  # sends a test email
  def self.test!
    simple(:to => '#{default_email}', :from => 'test@#{app_name}.com', :subject => 'Email delivery works', :body => 'Much success!').deliver
  end
END
  end
end

__END__
name: MailGun
description: Sets up everything needed for shooting email with MailGun
category: other