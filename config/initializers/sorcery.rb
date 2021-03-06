Rails.application.config.sorcery.submodules = [:activity_logging, :remember_me, :session_timeout, :user_activation, :brute_force_protection, :reset_password]

Rails.application.config.sorcery.configure do |config|
  
  config.session_timeout = 500.minutes
  config.session_timeout_from_last_action = false 
  
  config.user_config do |user| 
    user.user_activation_mailer = UserMailer
    user.reset_password_mailer = UserMailer
  end
  
  config.user_class = "User"

end
