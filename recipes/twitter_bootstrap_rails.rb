gem 'twitter-bootstrap-rails', :git => 'https://github.com/jonochang/twitter-bootstrap-rails.git'

if config['use_simple_form']
  after_everything do
    gsub_file "config/initializers/simple_form.rb", '# config.label_text = lambda { |label, required| "#{required} #{label}" }', 'config.label_text = lambda { |label, required| "#{label} #{required}" }'
    
    original_wrapper = <<-RB
  config.wrappers :class => :input, :error_class => :field_with_errors do |b|
    b.use :placeholder
    b.use :label_input
    b.use :hint,  :tag => :span, :class => :hint
    b.use :error, :tag => :span, :class => :error
  end
RB
    new_wrapper = <<-RB

  config.wrappers :inline, :class => 'clearfix', :error_class => :error do |b|
    b.use :placeholder
    b.use :label
    b.use :tag => 'div', :class => 'input' do |ba|
      ba.use :input
      ba.use :error, :tag => :span, :class => :'help-inline'
      ba.use :hint,  :tag => :span, :class => :'help-block'
    end
  end

  config.wrappers :stacked, :class => "clearfix", :error_class => :error do |b|
    b.use :placeholder
    b.use :label
    b.use :hint,  :tag => :span, :class => :'help-block'
    b.use :tag => 'div', :class => 'input' do |input|
      input.use :input
      input.use :error, :tag => :span, :class => :'help-inline'
    end
  end
RB
    gsub_file "config/initializers/simple_form.rb", original_wrapper, new_wrapper
    gsub_file "config/initializers/simple_form.rb", "# config.button_class = 'button'", "config.button_class = 'btn'"

    application_layout_body = <<-ERB
<body>

<%= yield %>

</body>
ERB

    application_layout_body_new = <<-ERB
<body>
  <div class="topbar">
    <div class="fill">
      <div class="container">

        <h3><%= link_to "TODO Logo", '/' %></h3>

        <ul class="nav">
          <li><%= link_to "Users", '/users' %></li>
        </ul>

        <% if not logged_in? %>

        <ul class="nav secondary-nav">
        </ul>
          
        <% else %>

          <ul class="nav secondary-nav">
            <li class="menu">
              <a class="menu" href="#">
                <%= current_user.name %>
                <i>(signed in with <%= current_user.provider.titleize %>)</i>
              </a>
              <ul class="menu-dropdown">
                <li><%= link_to "My Questions", user_questions_path(current_user) %></li>
                <li class="divider"></li>
                <li><%= link_to "Sign out", signout_path %></li>
              </ul>
            </li>
          </ul>

        <% end %>


      </div>
    </div>
  </div>

  <div class="container">
    <% if alert %>
      <div class="alert-message error"><%= alert %></div>
    <% end %>
    
    <% if notice %>
      <div class="alert-message info"><%= notice %></div>
    <% end %>

    <%= yield %>
  </div>

</body>

ERB

    gsub_file 'app/views/layouts/application.html.erb', application_layout_body, application_layout_body_new

  end

  create_file "app/assets/stylesheets/application.css.new", <<-CSS
/*
 * This is a manifest file that'll automatically include all the stylesheets available in this directory
 * and any sub-directories. You're free to add application-wide styles to this file and they'll appear at
 * the top of the compiled file, but it's generally better to create a new file per style scope.
 *= require_self
 *= require_tree . 
 *= require bootstrap-1.3.0.min
*/

label {
  margin-right: 20px;
}
CSS

  run 'mv app/assets/stylesheets/application.css.new app/assets/stylesheets/application.css'
end

__END__

name: Twitter Bootstrap Rails
description: Add Twitter Bootstrap CSS to project

category: stylesheet
exclusive: stylesheet
tags: [css, stylesheet]

run_after: [simple_form]
config:
  - use_simple_form:
      type: boolean
      prompt: "Using Simple Form?"
      if_recipe: simple_form


