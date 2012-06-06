require 'active_support/inflector'

class Default < Thor
  include Thor::Actions
  attr_reader :name

  source_root File.expand_path("../templates", __FILE__)

  desc "new NAME", "Create a new scroll"
  def new(name)
    @name = name
    template "new_scroll.tt", "scroll/#{name}.rb"
    `open scroll/#{name}.rb`
  end

end