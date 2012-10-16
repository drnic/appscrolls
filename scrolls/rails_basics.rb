after_bundler do
  # Setup home controller and default route
  generate "controller home index"

  # Make sure there is a default route
  unless File.open('config/routes.rb', 'r') { |f| f.read } =~ /\nroot/
    route "root :to => 'home#index'"
  end
  
  # Remove default static home page and move rails readme out of the way
  if scroll? 'git'
    git :rm => 'public/index.html'
    git :rm => 'app/assets/images/rails.png'
    create_file 'app/assets/images/.gitkeep'
    git :rm => 'README.rdoc'
  else
    remove_file 'public/index.html'
    remove_file 'app/assets/images/rails.png'
    remove_file 'README.rdoc'
  end

  # Setup app README with some diagnostic info
  create_file "README.md", <<-README
# #{@app_name.humanize}

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
run_after: [less]
