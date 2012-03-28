class RunTemplateGenerator < Rails::Generators::Base
  argument :template_path, :desc => "Path to an application template"
  
  def apply_template
    path = template_path
    unless path =~ /^https?:\/\//
      path = File.expand_path(path, Dir.pwd)
    end
    apply path
  end
end
