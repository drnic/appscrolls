if config.key?("providers")
  providers = config["providers"].split
else
  providers = []
  while providers.size == 0
    providers = ask_wizard("List desired omniauth strategies, space delimited (e.g. 'github facebook'; ENTER to see all):").split(' ')

    if providers.size == 0
      say_custom "omniauth", "Fetching list of all strategies"
      strategy_gems ||= `gem list --remote omniauth-`.split("\n").map{|strategy_gem| strategy_gem.match(/omniauth-(\w*)/)[1].ljust(20)}.uniq
      output_rows ||= (strategy_gems.length + (4 - (strategy_gems.length % 4)))/4 - 1 # 20 char per line
      (0..output_rows).each {|i| puts strategy_gems[i*4..(i+1)*4].join ' '}
    end
  end
end

providers.each do |provider|
  config["#{provider}_key"] = ask_wizard("#{provider.capitalize} key:") unless config.key?("#{provider}_key")
  config["#{provider}_secret"] = ask_wizard("#{provider.capitalize} secret:") unless config.key?("#{provider}_secret")

  case provider
  when 'angellist'
    gem "omniauth-angellist", :git => 'git://github.com/railsjedi/omniauth-angellist'
  else
    gem "omniauth-#{provider}"
  end
end

after_bundler do
  generate 'model authentications user_id:integer provider uid data:text'

  authentications_migration = Dir[destination_root + '/db/migrate/*.rb'].find { |file| file=~/create_authentications/ }
  gsub_file authentications_migration, ":user_id", ":user_id, :null => false"
  gsub_file authentications_migration, ":provider", ":provider, :null => false"
  gsub_file authentications_migration, ":uid", ":uid, :null => false"
  gsub_file authentications_migration, ":data", ":data, :null => false, :default => \"--- {}\\n\""
  inject_into_file authentications_migration, "\n    add_index :authentications, [:provider, :uid], :unique => true", :before => "\n  end"

  devise_migration = Dir[destination_root + '/db/migrate/*.rb'].find { |file| file=~/devise_create_users/ }
  gsub_file devise_migration, /t.string :email,\s*:null => false, :default => ""/, "t.string :email"
  inject_into_file devise_migration, "\n      t.string :name", :before => "\n      t.timestamps"
    
  providers.each do |provider|
    inject_into_file 'config/initializers/devise.rb', "\n  config.omniauth :#{provider}, Rails.configuration.#{provider}_key, Rails.configuration.#{provider}_secret, client_options", :after => "  # config.omniauth :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo'"
    inject_into_file 'config/application.rb', "\n    config.#{provider}_key = '#{config["#{provider}_key"]}'\n    config.#{provider}_secret = '#{config["#{provider}_secret"]}'\n", :after => "class Application < Rails::Application"
  end

  inject_into_file 'config/initializers/devise.rb', "\n  client_options = { :client_options => { :ssl => { :ca_file => '/etc/ssl/certs/ca-certificates.crt'} } }", :after => "  # config.omniauth :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo'"

  gsub_file 'app/models/user.rb', ':registerable', ':registerable, :omniauthable'
  user_authentication_code = <<-END

  has_many :authentications, :dependent => :destroy

  Authentication.providers.each do |provider|
    define_method provider do
      instance_variable_get("@\#{provider}") || instance_variable_set("@\#{provider}", authentications.where(:provider => provider).first)
    end
    define_method "\#{provider}_connected?" do
      send(provider) != nil
    end
  end

  def email_required?
    authentications.empty?
  end
END
  inject_into_file 'app/models/user.rb', user_authentication_code, :before => "\nend"

  gsub_file 'config/routes.rb', 'devise_for :users', 'devise_for :users, :controllers => { :omniauth_callbacks => "authentications" }'

  route <<-END
devise_scope :user do
    match 'users/unauth/:provider' => 'authentications#destroy', :as => 'unauth'
    match 'users/auth/:provider' => 'user_omniauth#authorize', :as => 'auth'
    match 'logout' => 'devise/sessions#destroy', :as => 'logout'
    get 'xx' => 'devise/registrations#destroy'
  end
END
end

after_everything do
  if scrolls.include? 'rails_basics'
    append_file 'app/views/home/index.html.haml', <<-END

- if current_user
  %p You are logged in as user #\#{current_user.id} \#{current_user.name} \#{current_user.email}
  %p= link_to "settings", edit_user_registration_path
  %p= link_to "log out", logout_path
  %p= link_to "delete user", user_registration_path, :data => { :confirm => "Are you sure?" }, :method => :delete
- unless current_user
  %p= link_to "create account", new_user_registration_path
  %p= link_to "login", new_user_session_path
- Authentication.providers.each do |provider|
  - if current_user && current_user.send("\#{provider}_connected?")
    %p= link_to "disconnect \#{provider}", unauth_path(provider)
  - else
    %p= link_to "connect \#{provider}", auth_path(provider)
END
  end
end


create_file "app/models/authentication.rb", <<-END
class Authentication < ActiveRecord::Base
  attr_accessible :data, :provider, :uid, :user_id
  belongs_to :user
  serialize :data

  def self.providers
    Devise.omniauth_providers
  end
end
END

create_file "app/controllers/authentications_controller.rb", <<-END
class AuthenticationsController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def method_missing(method, *args)
    raise "Unknown Provider Method: \#{method}" unless Authentication.providers.include?(method)

    omniauth = request.env['omniauth.auth']
    provider = omniauth['provider']
    uid = omniauth['uid']
    email = omniauth['info']['email']
    name = omniauth['info']['name']

    @user = User.includes(:authentications).merge(Authentication.where(:provider => provider, :uid => uid.to_s)).first

    if @user
      sign_in_and_redirect(:user, @user)
      flash[:notice] = "Welcome back."
    elsif current_user
      current_user.authentications.create(:provider => provider, :uid => uid, :data => omniauth)
      redirect_to(root_url)
      flash[:notice] = "\#{provider} successfully connected."
    else
      @user = User.find_by_email(email)
      if !@user
        @user = User.new
        @user.email = email # add users email from the returned authentication hash
        @user.password = (15..25).collect{(45..126).to_a[Kernel.rand(81)].chr}.join # randomize password for new users
      end
      @user.authentications.build(:provider => provider, :uid => uid, :data => omniauth)
      @user.save!

      sign_in_and_redirect(:user, @user)
      flash[:notice] = "Welcome!"
    end
    current_user.update_attribute(:email, email) if current_user.email.blank? && !email.blank?
    current_user.update_attribute(:name, name) if current_user.name.blank? && !name.blank?
  end

  def destroy
    provider = params[:provider]
    authentication = current_user.authentications.where(:provider => provider).first
    if !authentication
      flash[:notice] = "\#{provider} wasn't found."
    else
      authentication.destroy
      flash[:notice] = "\#{provider} disconnected."
    end
    redirect_to root_url
  end
end
END

__END__
name: OmniAuth
description: "Adds multi-strategy OmniAuth to Devise"
author: allangrant

exclusive: authentication
category: authentication
requires: [devise]
run_after: [devise, rails_basics]
