gem 'paper_trail', '~> 2'

after_bundler do
  generate "paper_trail:install"
end

__END__

name: Paper Trail
description: Plugin for tracking changes to your models' data. Good for auditing or versioning.

category: persistence
exclusive: activerecord_versioning
tags: [activerecord_versioning]


# TODO eycloud partner version of same name