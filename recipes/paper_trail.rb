gem 'paper_trail', '~> 2'

after_bundler do
  generate "paper_trail:install"
end

__END__

name: Paper Trail
description: Track changes to your models' data. Good for auditing or versioning.

category: activerecord_versioning
exclusive: activerecord_versioning
tags: [activerecord_versioning]


