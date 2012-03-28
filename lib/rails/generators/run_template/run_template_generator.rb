class RunTemplateGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :template_path, :desc => "Path to an application template"
  
  def apply_template
    path = template_path
    unless path =~ /^https?:\/\//
      path = File.expand_path(path, Dir.pwd)
    end
    apply path
  end
end
