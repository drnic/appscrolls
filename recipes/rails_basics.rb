# create rvmrc file
create_file ".rvmrc", "rvm gemset create '#{app_name}' \nrvm gemset use '#{app_name}'"

gem 'rake', '~> 0.8.7'  #http://stackoverflow.com/questions/5287121/undefined-method-task-using-rake-0-9-0-beta-4

after_everything do
  # clean up rails defaults
  remove_file "public/index.html"
  remove_file "public/images/rails.png"
  
  if recipes.include? 'git'
    append_file ".gitignore", "\nconfig/database.yml"
    append_file ".gitignore", "\public/system"
  end
  
  rake "db:migrate"
end

__END__

name: rails_basics
description: "Best practices for new rails apps"
author: amolk

exclusive: rails_basics
category: rails_basics