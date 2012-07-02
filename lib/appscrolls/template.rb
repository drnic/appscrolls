module AppScrolls
  class Template
    attr_reader :scrolls, :unknown_scroll_names, :config_script

    def initialize(scrolls, options={})
      @unknown_scroll_names = []
      @config_script = options[:config_script]
      @scrolls = scrolls.inject([]) do |list, name|
        scroll = AppScrolls::Scroll.from_mongo(name)
        if scroll
          list << scroll
        else
          @unknown_scroll_names << name
          $stderr.puts "Unknown scroll '#{name}'. Skipping."
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


    def resolve_scrolls
      return @resolve_scrolls if @resolve_scrolls
      priority_map = {} # for each scroll (key), array of scrolls that must run earlier
      scrolls_with_dependencies.each do |scroll|
        (priority_map[scroll.key] ||= []).push(*scroll.run_after)
        scroll.run_before.each do |scroll_to_run_later|
          if scrolls_with_dependencies.find{|s| s.key == scroll_to_run_later} # if a scroll must run before another included scroll
            (priority_map[scroll_to_run_later] ||= []).push scroll.key # add a dependency to that scroll
          end
        end
      end
      priority_map.each_value do |precursors| # remove scrolls we're not using from the dependencies
        precursors.reject! do |key|
          !scrolls_with_dependencies.find{|s| s.key == key}
        end
      end
      @resolve_scrolls = []
      while scroll_without_precursors = priority_map.find{|key, value| value.empty?} # pop a scroll without dependencies
        key, empty_array = scroll_without_precursors
        priority_map.delete(key)
        scroll = scrolls_with_dependencies.find{|s| s.key == key}
        raise key if !scroll
        @resolve_scrolls << scroll # stick it into our result queue
        priority_map.each_value{|precursors| precursors.delete(key)} # take it off other scroll's dependency lists
      end
      unless priority_map.empty?
        raise "circular dependency with run_after/run_before clauses: #{priority_map.inspect}"
      end
      @resolve_scrolls
    end

    def scroll_classes
      @scroll_classes ||= scrolls.map { |name| AppScrolls::Scroll.from_mongo(name) }
    end

    def scrolls_with_dependencies
      @scrolls_with_dependencies ||= scroll_classes
      
      added_more = false
      for scroll in scroll_classes
        scroll.requires.each do |requirement|
          requirement = AppScrolls::Scroll.from_mongo(requirement)
          count = @scrolls_with_dependencies.size
          (@scrolls_with_dependencies << requirement).uniq!
          unless @scrolls_with_dependencies.size == count
            added_more = true
          end
        end
      end

      added_more ? scrolls_with_dependencies : @scrolls_with_dependencies
    end

    def compile
      render 'layout', binding
    end

    def args
      scrolls.map(&:args).uniq
    end
    
    def custom_code?; false end
    def custom_code; nil end
  end
end
