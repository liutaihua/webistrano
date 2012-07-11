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
    :address  => "your.smtp.com",
    :port  => 25, 
    :domain  => "smtp.com",
    :user_name  => "your_smtp_username",
    :password  => "your_smtp_passwd",
    :authentication  => :login
  },
  
  # Sender address for Webistrano emails
  :webistrano_sender_address => "webistrano@snda.com",
  
  # Sender and recipient for Webistrano exceptions
  :exception_recipients => "defage@gmail.com",
  :exception_sender_address => "defage@gmail.com"

}

MyCfg = {
  :git_server => 'repo.op.sdo.com',
  :no_rights => '权限不足，禁止操作!',
  :rsync_root => '/var/grepos/',
  :email_grp => %w{defage@gmail.com defage@163.com},
  :per_page => 10,
  :recent => 6,
  :debug => false,
  :superpass => 'a966cc8f48',
  :rev_reg => /^((?:[A-Za-z0-9.]*_){4})[A-Za-z0-9.]*(\d{1,2})$/i,
  :git_root => '/home/git/repositories',
  :git_path_var => 'src_path'
}
