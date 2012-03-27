require 'rails_wizard/scrolls'
require 'rails_wizard/scroll'
require 'rails_wizard/config'
require 'rails_wizard/template'

Dir[File.dirname(__FILE__) + '/../scrolls/*.rb'].each do |path|
  key = File.basename(path, '.rb')
  scroll = RailsWizard::Recipe.generate(key, File.open(path))
  RailsWizard::Recipes.add(scroll)
end
