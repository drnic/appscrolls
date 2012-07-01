after_everything do

  apply_diff
  
end

__END__
name: Devise HAML
description: "Replace Devise views with HAML"
author: allangrant
category: templating
requires: [devise, simple_form, git]
run_after: [devise]
