if config['use_carrierwave']
  gem 'carrierwave_direct'
end

__END__

name: Carrierwave Direct
description: "Use Carrierwave Direct for uploading carrierwave files directly to Amazon S3"
author: jonochang

exclusive: file-uploads 
category: file-uploads
tags: [file-uploads]
run_after: [carrierwave]

config:
  - use_carrierwave:
      type: boolean
      prompt: "Use the CarrierWave Direct addon?"
      if_recipe: carrierwave

