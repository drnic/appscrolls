before_everything do
  git :init
  git :add => '.'
  git :commit => '-m "Fresh rails app before customizations."'
end

__END__

name: Git
description: "Initialize repo and instruct main layout template to commit after each scroll."
author: mbleigh

exclusive: scm
category: deployment

