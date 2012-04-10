gem_group :assets do
  gem 'twitter-bootstrap-rails'
end

after_bundler do
  generate "bootstrap:install"
  layout = config["twitter_bootstrap_layout"]
  generate "bootstrap:layout application #{layout} -f"
  
  html_to_find = layout == "fluid" ? '<div class="row-fluid">' : '<div class="content">'
  gsub_file "app/views/layouts/application.html.erb", /#{html_to_find}/, <<-HTML
<% flash.each do |name, msg| %>
        <div class="alert alert-<%= name == :notice ? "success" : "error" %>">
          <a class="close" data-dismiss="alert">×</a>
          <%= msg %>
        </div>
      <% end %>
      #{html_to_find}
HTML

end

__END__

name: Twitter Bootstrap Rails
description: Add Twitter Bootstrap CSS

category: stylesheet
exclusive: stylesheet
tags: [css, stylesheet]

requires: [simple_form, rails_basics]
run_before: [simple_form]

config:
  - twitter_bootstrap_layout:
      prompt: "Which Twitter Bootstrap layout?"
      type: multiple_choice
      choices: [["Fluid", "fluid"], ["Fixed", "fixed"]]


