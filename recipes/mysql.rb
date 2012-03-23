if recipe?("sqlite3")
  gem "mysql2", :group => :production
else
  gem "mysql2"
end  
# TODO what about Windows?
# TODO what if you only want MySQL in production?

# TODO generate config/database.yml for DBs

if recipe?("eycloud")
  mysql_versions = [
    ["MySQL 5.0", "mysql_50"],
    ["MySQL 5.5 (beta)", "mysql_55"]
  ]
  @mysql_stack = multiple_choice("Create app to which Engine Yard Cloud account?", mysql_versions)
end

__END__

name: MySQL
description: Use MySQL for production database (and development/testing if SQLite3 not selected)
author: drnic

exclusive: orm
category: persistence
tags: [sql, orm, mysql]
