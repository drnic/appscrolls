gem 'fog'
gem 'carrierwave'

region = config['region']
bucket = ask_wizard("Please enter S3 bucket")

carrierwave_initializer = <<-RB
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'CHANGEME',
    :aws_secret_access_key  => 'CHANGEME',
    :region                 => '#{region}'
  }
  config.fog_directory  = '#{bucket}'
  config.fog_public     = true
  # config.fog_host       = 'https://assets.changeme.com.au'
  # config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end
RB

end

__END__

name: Carrierwave
description: "Use Carrierwave for file uploading"
author: jonochang

exclusive: file-uploads 
tags: [file-uploads]

config:
  - region:
      type: multiple_choice
      prompt: "Which region are you using?"
      choices:
        - ["US Standard", us-east-1]
        - ["Oregon", us-west-2]
        - ["Ireland", eu-west-1]
        - ["Singapore", ap-southeast-1]
        - ["Tokyo", ap-northeast-1]
