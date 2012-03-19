# create rvmrc file
create_file ".rvmrc", "rvm gemset create '#{app_name}' \nrvm gemset use '#{app_name}'"

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

name: Rails Basics
description: Best practices for new rails apps
author: amolk
