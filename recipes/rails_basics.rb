# create rvmrc file
create_file ".rvmrc", "rvm gemset create '#{app_name}' \nrvm gemset use '#{app_name}'"

after_bundler do
  # clean up rails defaults
  remove_file "public/index.html"
  remove_file "public/images/rails.png"
  run "mv README.rdoc RAILS_README.rdoc"
  remove_file "README.rdoc"
  create_file "README.md", <<-README
# ReadMe


## Deployment

```
ey deploy
```

## Thanks

The original scaffold for this application was created by [Engine Yard Rails Wizard](http://railswizard.engineyard.com).

README
  create_file "EngineYardCloud.md", <<-README
# Using Engine Yard Cloud

## Initial Deployment

* Host this git repository (such as on [GitHub](https://github.com))
* From the [Dashboard](https://cloud.engineyard.com/), click "New an Application"
* Add the "Git Repository URI"
* Click "Create Application"
* Add an Environment Name
* Click "Create Environment"
* Click "Boot this Configuration"

README
  
  if recipes.include? 'git'
    append_file ".gitignore", "\nconfig/database.yml"
    append_file ".gitignore", "\public/system"
  end
  
  rake "db:migrate"
end

__END__

name: Rails Basics
description: Best practices for new Rails apps
author: drnic
