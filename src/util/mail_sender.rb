require 'singleton'
require 'net/smtp'
require 'pony'

class MailSender

  include Singleton

  Account = "3lozovisarmi@gmail.com"
  Password = "3zelevisarmi"

  def send_email(params)
   if(/\A\d+@sms\.mtel\.net\Z/.match params[:to]) then
     params[:from] = "home"
     params[:headers] = {"Content-Type" => "text/html"}
     p Pony.mail params
   else
     message = params[:body]
     smtp = Net::SMTP.new 'smtp.gmail.com', 587
     smtp.enable_starttls
     smtp.start 'gmail.com', Account, Password, :login
     smtp.send_message message, Account, params[:to]
     smtp.finish 
   end
  end

end
