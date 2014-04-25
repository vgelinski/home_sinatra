require 'singleton'
require 'rufus/scheduler'
require './src/util/device_manager.rb'
require './src/model/statistic.rb'
require './src/util/settings.rb'
require './src/util/mail_sender.rb'


class Ticker

  include Singleton

  def initialize
    @scheduler = Rufus::Scheduler::PlainScheduler.start_new
    @device_manager = DeviceManager.instance
  end

  def start
    at_start unless @started
    @started = true
  end

  def stop
  end

  def set_alarm(time)
    parts = time.split(":").map {|part| part.to_i}
    now = Time.new
    year, month, date = now.year, now.month, now.day
    target = Time.local year, month, date, parts[0], parts[1], 0
    target = now < target ? target : target + (24*60*60)
    alarm = @scheduler.in target - now do
      @device_manager.turn_lamp_on
      Settings.alarm_time = nil
    end
    alarm.job_id
  end

  def cancel_alarm(alarm_id)
    @scheduler.unschedule alarm_id
  end

  private

  def at_start
    @scheduler.every '1m', :first_in => next_round_minute - Time.new do
      each_minute
    end

    @scheduler.every '1s' do
      each_second
    end
  end

  def each_second
  end

  def each_minute
    @temperature = @device_manager.temperature

    write_statistics
    notify_if_should
  end

  def write_statistics
    to = next_round_minute
    since = to - 60
    period = Period.create since: since, to: to
    consumption = (Settings.heater_power * (1.0/60)).to_d
    day = Settings.day? since
    night = !day
    daily_consumption = day ? consumption : 0;
    night_consumption = night ? consumption : 0;
    daily_cost = day ? consumption * Settings.day_cost : 0;
    night_cost = night ? consumption * Settings.night_cost : 0;

    daily_consumption = daily_consumption.round 15
    night_consumption = night_consumption.round 15
    daily_cost = daily_cost.round 15
    night_cost = night_cost.round 15

    params = {
      period: period, 
      temperature: @temperature,
      daily_consumption: daily_consumption,
      night_consumption: night_consumption,
      daily_cost: daily_cost,
      night_cost: night_cost
    }

    statistic = Statistic.create params 
    statistic.save

    statistic.errors.each do |e|
      puts "error: #{e}"
    end

    puts "at #{Time.new} temperature was #{@temperature}"
  end

  def notify_if_should
    now = Time.new
    sender = MailSender.instance

    temperature_below_min = @temperature < Settings.minimal_temperature_to_notify
    if(temperature_below_min && Settings.temperature_notifyng_enabled?) then
      @last_temperatyre_notify ||= Time.at 0
      time_from_last_notify = (now.to_i - @last_temperature_notify.to_i) / 60
      if(time_from_last_notify > Settings.temperature_notify_minimal_interval) then
        Settings.emails_to_notify.each do |email|
          sender.send_email(
            to: email,
            subject: "Low temperature alert",
            body: "The temperature in your home is below minmimum!\n" +
                  "At #{now} #{@temperature.round 1} temperature was measured."
          )
          puts "Sended to #{email}"
        end
        @last_temperature_notify = now
      end
    end
  end

  def next_round_minute
    now = Time.new
    now + 60 - now.sec
  end

end
