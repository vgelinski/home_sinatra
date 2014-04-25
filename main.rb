require 'sinatra'
enable :sessions
enable :run
#Setting up the Database
require 'data_mapper'

DataMapper::Logger.new $stdout, :debug
#DataMapper.setup :default, 'sqlite::memory:'
#DataMapper.setup :default, "sqlite:db/prod.db"
DataMapper.setup :default, "sqlite:db/dev.db"

#External libraries
require 'slim'
require 'json'
#require 'digest/sha1'
#require 'sinatra-authentication'


#My classes
require './src/model/statistic.rb'
require './src/util/ticker.rb'
require './src/util/mail_sender.rb'
require './src/model/user.rb'

#Finalizing database
DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

require './default_settings.rb'


use Rack::Session::Cookie, secret: (0..20).map{(33 + rand(92)).chr}.join

use Rack::Auth::Basic, "Welcome, please authorise" do |username, password|
  User.all.any? do |user|
    user.check username, password
  end
end

TimeRegex = /\A\d\d:\d\d\Z/
NumberRegex = /\A\-?\d+(.\d)?\d*\Z/
MailRegex = /\A[\w\._\-]+@[\w\._\-]+\.[\w]+\Z/

Validations = {}
Validations["day_start"] = TimeRegex
Validations["day_end"] = TimeRegex
Validations["day_cost"] = NumberRegex
Validations["night_cost"] = NumberRegex
Validations["heater_power"] = NumberRegex
Validations["temperature_notify_minimal_interval"] = NumberRegex
Validations["notify_emails"] = MailRegex
Validations["minimal_temperature_to_notify"] = NumberRegex

get '/' do
  @current_page = "home"
  slim :home
end

get '/statistics' do
  @current_page = "statistics"
  slim :statistics
end

post '/get_statistics' do
  responce = {}
  since = Time.at params["since"].to_i
  to = Time.at params["to"].to_i
  period = Period.new since: since, to: to 
  interval = params["interval"]
  Statistic.loadd(period, interval).select{|s| s != nil}.map do |statistic|
    middle = (statistic.period.since.to_i + statistic.period.to.to_i)/2
    responce[middle.to_i] = [
      statistic.period.since.to_i,
      statistic.period.to.to_i,
      statistic.temperature.to_s('F').to_f,
      statistic.daily_consumption.to_s('F').to_f,
      statistic.night_consumption.to_s('F').to_f,
      statistic.daily_cost.to_s('F').to_f,
      statistic.night_cost.to_s('F').to_f]
  end
  responce.to_json
end

get '/live' do
  @current_page = "live"
  slim :live
end

get '/control_panel' do
  @current_page = "control_panel"
  slim :control_panel
end

get '/settings' do
  @current_page = "settings"
  slim :settings
end

post '/set_settings' do
  responce = {}
  params.keys.each do |key|
    #puts "proba #{key}, #{params[key]}"
    value = params[key]
    if(Validations[key] != nil && Validations[key].match(value) != nil) then
      Settings.set key, params[key]
      responce[key] = "succ"
    else
      responce[key] = "fail"
    end
  end
  responce.to_json
end

get '/notification' do
  @current_page = "notification"
  slim :notification
end

post '/set_notifications' do
  responce = {}
  params.keys.each do |key|
    value = params[key]
    case key
      when  "notify_emails"
        all_emails = params[key].split("\n").map{ |e| e.strip}
        valid_emails = all_emails.select{ |e| Validations[key].match e}
        invalid_emails = all_emails.select{ |e| !(Validations[key].match e) }
        Settings.emails_to_notify = valid_emails
        valid_emails.each{ |e| responce[e] = "succ" }
        invalid_emails.each{ |e| responce[e] = "fail" }
      when "minimal_temperature_to_notify"
        if(Validations[key].match value) then
          Settings.minimal_temperature_to_notify = value
          responce[key] = "succ"
        else
          responce[key] = "fail"
        end
      when "temperature_notify_enabled"
        if(value == "true") then
          Settings.enable_temperature_notifyng
        else
          Settings.disable_temperature_notifyng
        end
      when "temperature_notify_minimal_interval"
        if(Validations[key].match value) then
          Settings.temperature_notify_minimal_interval = value
          responce[key] = "succ"
        else
          responce[key] = "fail"
        end
      end
  end
  puts "proba #{responce}"
  responce.to_json
end

post '/false_alarm' do
  sender = MailSender.instance
  Settings.emails_to_notify.each do |email|
    sender.send_email(
      to: email,
      subject: "False alaram",
      body: "This is false alarm email"
    )
  end
end

post '/change_lamp_state' do
  responce = {}
  manager = DeviceManager.instance
  case params["state"]
    when "on"
      manager.turn_lamp_on
    when "off"
      manager.turn_lamp_off
    when "check"
      #just checking, perform no action
  end
  responce["lamp_status"] = manager.is_lamp_on? ? "on" : "off"
  responce.to_json
end

post '/set_alarm' do
  responce = {}
  ticker = Ticker.instance
  time = params["alarm_time"]
  if(time && (TimeRegex.match time)) then
    Settings.alarm_id = ticker.set_alarm time
    Settings.alarm_time = time
    responce["alarm"] = "on"
  else
    ticker.cancel_alarm Settings.alarm_id
    Settings.alarm_time = nil
    responce["alarm"] = "off"
  end
  responce.to_json
end

ticker = Ticker.instance
ticker.start
