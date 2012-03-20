module RailsWizard
  class Template
    attr_reader :recipes, :unknown_recipe_names

    def initialize(recipes)
      @unknown_recipe_names = []
      @recipes = recipes.inject([]) do |list, name|
        recipe = RailsWizard::Recipe.from_mongo(name)
        if recipe
          list << recipe
        else
          @unknown_recipe_names << name
          $stderr.puts "Unknown recipe '#{name}'. Skipping."
        end
        list
      end
    end

    def self.template_root
      File.dirname(__FILE__) + '/../../templates'
    end

    def self.render(template_name, binding = nil)
      erb = ERB.new(File.open(template_root + '/' + template_name + '.erb').read)
      erb.result(binding)
    end
    def render(template_name, binding = nil); self.class.render(template_name, binding) end


    def resolve_recipes
      @resolve_recipes ||= recipes_with_dependencies.sort
    end

    def recipe_classes
      @recipe_classes ||= recipes.map { |name| RailsWizard::Recipe.from_mongo(name) }
    end

    def recipes_with_dependencies
      @recipes_with_dependencies ||= recipe_classes
      
      added_more = false
      for recipe in recipe_classes
        recipe.requires.each do |requirement|
          requirement = RailsWizard::Recipe.from_mongo(requirement)
          count = @recipes_with_dependencies.size
          (@recipes_with_dependencies << requirement).uniq!
          unless @recipes_with_dependencies.size == count
            added_more = true
          end
        end
      end

      added_more ? recipes_with_dependencies : @recipes_with_dependencies
    end

    def compile
      render 'layout', binding
    end

    def args
      recipes.map(&:args).uniq
    end

    def custom_code?; false end
    def custom_code; nil end
  end
end
