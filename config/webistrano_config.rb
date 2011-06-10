# 
#  Example Webistarno configuration
#  
#  copy this file to config/webistrano.rb and edit
#
WebistranoConfig = {

  # secret password for session HMAC
  :session_secret => '1820ac3bc91ccdcf3027aa2c493945f9',

  # Uncomment to use CAS authentication
  # :authentication_method => :cas,
  
  # SMTP settings for outgoing email
  :smtp_delivery_method => :smtp,
  
  :smtp_settings => {
    :address  => "mail.snda.com",
    :port  => 25, 
    :domain  => "snda.com",
    :user_name  => "ptwarn",
    :password  => "8ikju76yh",
    :authentication  => :login
  },
  
  # Sender address for Webistrano emails
  :webistrano_sender_address => "webistrano@snda.com",
  
  # Sender and recipient for Webistrano exceptions
  :exception_recipients => "liutaihua@snda.com",
  :exception_sender_address => "liutaihua@snda.com"

}
