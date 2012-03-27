gem "nifty-generators"
after_bundler do
  remove_file 'app/views/layouts/application.html.erb' # use nifty layout instead
  
  if scrolls.include? 'haml'
    generate 'nifty:layout --haml'
  else
    generate 'nifty:layout'
  end

  generate 'nifty:config'

end
__END__

name: nifty-generators
description: "Use RyanB's nifty template generators."
author: amolk

category: templating
exclusive: template_generator