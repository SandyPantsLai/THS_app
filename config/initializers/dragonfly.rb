=begin
require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "37d5cc620858b6f63861bbc40c15b9e783e69b97be22fae05d493e85826069fc"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
=end