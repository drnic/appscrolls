gem 'exception_notification', :group => 'production'

initializer 'exception_notification.rb', <<-END
if defined? ExceptionNotifier
  Rails.application.config.middleware.use ExceptionNotifier,
        :email_prefix => "[#{app_name}] ",
        :sender_address => %{"notifier" <notifier@#{app_name}.com>},
        :exception_recipients => %w{exception@#{app_name}.com}
end
END

__END__

name: Exception Notification
description: Exception Notifier Plugin for Rails

category: exception_notification
exclusive: exception_notification
tags: [exception_notification]
