Rails.application.config.sorcery.submodules = [:activity_logging, :remember_me, :session_timeout, :user_activation]

Rails.application.config.sorcery.configure do |config|
  
  config.session_timeout = 10.minutes
  config.session_timeout_from_last_action = false 
  
  config.user_config do |user| 
    user.user_activation_mailer = UserMailer
  end
  
  config.user_class = "User"

end
