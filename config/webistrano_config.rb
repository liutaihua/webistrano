# 
#  Example Webistarno configuration
#  
#  copy this file to config/webistrano.rb and edit
#
WebistranoConfig = {

  # secret password for session HMAC
  :session_secret => 'your_session_secret',

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
  :exception_recipients => "foo@snda.com",
  :exception_sender_address => "bar@snda.com"

}

MyCfg = {
  :git_server => 'yours.domain.com',
  :no_rights => '权限不足，禁止操作!',
  :rsync_root => '/path/to/your/rsync/root',
  :email_grp => %w{foo@snda.com bar@snda.com},
  :per_page => 10,
  :recent => 6
}
