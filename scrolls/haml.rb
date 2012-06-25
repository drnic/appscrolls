gem 'haml-rails'

after_everything do
  create_file 'app/views/layouts/application.html.haml', <<-END
!!! 5
%html{html_attrs}
  %head
    %meta{:charset => 'utf-8'}
    %title #{app_name}
    = csrf_meta_tag
    = stylesheet_link_tag "application", :media => "all"
    = javascript_include_tag "application"
  %body
    .container
      - flash.each do |name, msg| 
        .alert{:class => "alert-\#{name == :alert ? "error" : "success"}"}
          %a.close{:"data-dismiss" => "alert"} ×
          != msg
      = yield
END
  run 'rm app/views/layouts/application.html.erb'
end

__END__

name: HAML
description: "Utilize HAML for templating."

category: templating
exclusive: templating
