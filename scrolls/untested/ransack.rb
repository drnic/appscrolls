gem 'ransack'

create_file "config/initializers/ransack.rb", <<-RUBY
Ransack.configure do |config|
  # config.add_predicate 'equals_diddly', # Name your predicate
  #                      # What non-compound ARel predicate will it use? (eq, matches, etc)
  #                      :arel_predicate => 'eq',
  #                      # Format incoming values as you see fit. (Default: Don't do formatting)
  #                      :formatter => proc {|v| "#{v}-diddly"},
  #                      # Validate a value. An "invalid" value won't be used in a search.
  #                      # Below is default.
  #                      :validator => proc {|v| v.present?},
  #                      # Should compounds be created? Will use the compound (any/all) version
  #                      # of the arel_predicate to create a corresponding any/all version of
  #                      # your predicate. (Default: true)
  #                      :compounds => true,
  #                      # Force a specific column type for type-casting of supplied values.
  #                      # (Default: use type from DB column)
  #                      :type => :string
end
RUBY

__END__

name: Ransack
description: Extensible searching for Rails - successor to ransack

category: search
exclusive: search
tags: [search]


