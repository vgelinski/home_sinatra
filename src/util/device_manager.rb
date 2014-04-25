require 'snmp'
require 'singleton'

class DeviceManager

  include Singleton

  Host = '192.168.1.135'
  ReadCommunity = '000000000000'
  WriteCommunity = 'private'
  Line = '1.3.6.1.4.1.19865.1.2.3.1.0'

  Port1 = '1.3.6.1.4.1.19865.1.2.2.1.0'

  LampPort = Port1

  def initialize
  end

  def temperature
    line = nil
    SNMP::Manager.open :host => Host, :community => ReadCommunity do |manager|
      line = get_value manager, Line
      line = line.to_i
    end
    calculate_temperature line
   # Random.new.rand(2..25)
  end

  def turn_heater_on
  end

  def turn_heater_off
  end

  def turn_lamp_on
    SNMP::Manager.open :host => Host, :community => WriteCommunity do |manager|
      manager.set SNMP::VarBind.new LampPort, SNMP::Integer.new(1)
    end
  end

  def turn_lamp_off
    SNMP::Manager.open :host => Host, :community => WriteCommunity do |manager|
      manager.set SNMP::VarBind.new LampPort, SNMP::Integer.new(0)
    end
  end

  def is_lamp_on?
    lamp = nil
    SNMP::Manager.open :host => Host, :community => ReadCommunity do |manager|
      lamp = get_value manager, LampPort
      lamp = lamp.to_i
    end
    lamp == 1
  end

  private

  def get_value(manager, param)
    result = nil;
    responce = manager.get [param]
    responce.each_varbind { |vb| result = vb.value.to_s }
    result
  end

  def calculate_temperature(line)
    voltage = 3300.0 * (line / 1023.0)
    (voltage - 500)/10
  end

end
