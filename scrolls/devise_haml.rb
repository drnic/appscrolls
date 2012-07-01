after_everything do

  if scrolls.include?('simple_form')
    apply_patch :simple_form
  else
    apply_patch
  end
end

__END__
name: Devise HAML
description: "Replace Devise views with HAML"
author: allangrant
category: templating
requires: [devise, git, haml]
run_after: [devise]
