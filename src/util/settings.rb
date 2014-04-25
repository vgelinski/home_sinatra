require 'data_mapper'

class Settings

  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :value, String

  def Settings.day?(time)
    parts = get("day_start").split ":"
    fhour, fmin, fsec = parts[0].to_i, parts[1].to_i, 0
    since = Time.local time.year, time.month, time.day, fhour, fmin, fsec
    parts = get("day_end").split ":"
    thour, tmin, tsec = parts[0].to_i, parts[1].to_i, 0
    to = Time.local time.year, time.month, time.day, thour, tmin, tsec
    time >= since and time <= to
  end

  def Settings.set_day(params)
    set "day_start", params[:day_start]
    set "day_end", params[:day_end]
  end

  def Settings.heater_power
    value = get "heater_power"
    value ? BigDecimal.new(value) : 0
  end

  def Settings.heater_power=(power)
    set "heater_power", power
  end

  def Settings.day_cost
    value = get "day_cost"
    value ? BigDecimal.new(value) : 0
  end

  def Settings.day_cost=(cost)
    set "day_cost", cost
  end

  def Settings.night_cost
    value = get "night_cost"
    value ? BigDecimal.new(value) : 0
  end

  def Settings.night_cost=(cost)
    set "night_cost", cost
  end

  def Settings.temperature_notifyng_enabled?
    get("temperature_notify") == "true"
  end

  def Settings.enable_temperature_notifyng
    set "temperature_notify", "true"
  end

  def Settings.disable_temperature_notifyng
    set "temperature_notify", "false"
  end

  def Settings.emails_to_notify
    get_multiple "temperature_email"
  end

  def Settings.emails_to_notify=(emails)
    set_multiple "temperature_email", emails
  end

  def Settings.temperature_notify_minimal_interval
    int = get "temperature_notify_min_interval"
    int == nil ? 0 : int.to_i
  end

  def Settings.temperature_notify_minimal_interval=(int)
    set "temperature_notify_min_interval", int
  end

  def Settings.minimal_temperature_to_notify
    t = get "minimal_temperature_to_notify"
    t == nil ? 0 : (BigDecimal.new t)
  end

  def Settings.minimal_temperature_to_notify=(value)
    set "minimal_temperature_to_notify", value
  end

  def Settings.alarm_time
    get "alarm_time"
  end

  def Settings.alarm_time=(time)
    set "alarm_time", time
  end

  def Settings.alarm_id
    get "alarm_id"
  end

  def Settings.alarm_id=(id)
    set "alarm_id", id
  end

  def Settings.set(name, value)
    current = Settings.first(name: name)
    if(current) then
      current.update(value: value)
      current.save
    else
      Settings.create name: name, value: value
    end
  end

  def Settings.get(name)
    current = Settings.first name: name
    current ? current.value : nil
  end

  def Settings.get_multiple(name)
    Settings.all(name: name).map { |s| s.value}
  end

  def Settings.set_multiple(name, values)
    remove_all name
    values.each do |value|
      Settings.create name: name, value: value
    end
  end

  def Settings.add(name, value)
    Settings.create name: name, value: value
  end

  def Settings.remove(name, value)
    Settings.all(name: name, value: value).destroy
  end

  def Settings.remove_all(name)
    Settings.all(name: name).destroy
  end

end
