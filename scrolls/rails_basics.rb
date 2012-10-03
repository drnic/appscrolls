before_everything do
  # remove commented lines and multiple blank lines from Gemfile
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"

  # remove commented lines and multiple blank lines from config/routes.rb
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
end

after_bundler do
  # Setup home controller and default route
  generate "controller home index about contact"
  route "root :to => 'home#index'"
  
  # Remove default static home page and move rails readme out of the way
  if scroll? 'git'
    git :rm => 'public/index.html'
    git :rm => 'app/assets/images/rails.png'
    create_file 'app/assets/images/.gitkeep'
    git :mv => 'README.rdoc doc/RAILS_README.rdoc'
  else
    remove_file "public/index.html"
    remove_file "app/assets/images/rails.png"
    run 'mv README.rdoc doc/RAILS_README.rdoc'
  end

  # Setup app README with some diagnostic info
  create_file "README.md", <<-README
# #{@app_name.humanize}

## Deployment

## Thanks

The original scaffold for this application was created by [App Scrolls](http://appscrolls.org).

The project was created with the following scrolls:

#{ scrolls.map {|r| "* #{r}"}.join("\n")}
README

  # Ignore some files
  if scroll? 'git'
    append_file ".gitignore", "\nconfig/database.yml"
    append_file ".gitignore", "\npublic/system"
  end
end

after_everything do
  rake "db:migrate"
end

__END__

name: Rails Basics
description: Best practices for new Rails apps
author: drnic

run_before: []
