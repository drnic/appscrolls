# create rvmrc file
# create_file ".rvmrc", "rvm gemset create '#{app_name}' \nrvm gemset use '#{app_name}'"

after_bundler do
  # clean up rails defaults
  remove_file "public/index.html"
  remove_file "public/images/rails.png"
  generate "controller home index"
  route "root :to => 'home#index'"
  
  run "mv README.rdoc RAILS_README.rdoc"
  remove_file "README.rdoc"
  create_file "README.md", <<-README
# ReadMe


## Deployment

```
ey deploy
```
Remove
## Thanks

The original scaffold for this application was created by [App Scrolls](http://appscrolls.org).

The project was created with the following scrolls:
```
appscrolls new #{app_name} #{ scrolls.join(" ") }
```

README

  if scrolls.include? 'git'
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
run_before: [git]