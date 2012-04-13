module AppScrollsScrolls
  module Scrolls
    @@categories = {}
    @@list = {}

    def self.add(scroll)
      AppScrollsScrolls::Scrolls.const_set ActiveSupport::Inflector.camelize(scroll.key.gsub("-", "_")), scroll
      @@list[scroll.key] = scroll
      (@@categories[scroll.category.to_s] ||= []) << scroll.key
      @@categories[scroll.category.to_s].uniq!
      scroll
    end

    def self.[](key)
      @@list[key.to_s]
    end

    def self.list
      @@list.keys.sort
    end

    def self.list_classes
      @@list.values.sort_by{|c| c.key}
    end

    def self.categories
      @@categories.keys.sort
    end

    def self.for(category)
      (@@categories[category.to_s] || []).sort
    end

    def self.remove_from_category(category, scroll)
      (@@categories[category.to_s] ||= []).delete(scroll.key)
    end
  end
end
