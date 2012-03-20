if recipe?("sqlite3")
  gem "mysql2", :group => :production
else
  gem "mysql2", :group => :production
end  
# TODO what about Windows?
# TODO what if you only want MySQL in production?

# TODO generate config/database.yml for DBs

__END__

name: MySQL
description: Use MySQL for production database (and development/testing if SQLite3 not selected)
author: drnic

exclusive: orm
category: persistence
tags: [sql, orm, mysql]
