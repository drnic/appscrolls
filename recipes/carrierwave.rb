gem 'carrierwave'

if config['use_fog']
  
end

__END__

name: Carrierwave
description: "Use Carrierwave for file uploading"
author: jonochang

exclusive: file-uploads 
category: file-uploads
tags: [file-uploads]
run_after: [fog]

config:
  - use_fog:
      type: boolean
      prompt: "Use Fog with AWS as the storage provider?"
      if_recipe: fog

