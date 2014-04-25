require './src/model/period.rb'
require './src/util/calendar.rb'
require 'data_mapper'

class Fixnum
  def nan?
    true
  end
end

class Statistic

  include DataMapper::Resource

  property :id, Serial
  property :temperature, Decimal, :scale => 18, :precision => 20
  property :daily_consumption, Decimal, :scale => 18, :precision => 20
  property :night_consumption, Decimal, :scale => 18, :precision => 20
  property :daily_cost, Decimal, :scale => 18, :precision => 20
  property :night_cost, Decimal, :scale => 18, :precision => 20


  belongs_to :period, :model => Period, :required => true

  def Statistic.loadd(period, interval)
    calendar = Calendar.new
    interval = interval.to_sym
    result = []
    index = 0
    calendar.each(period.since, period.to, interval).each_cons 2 do |n|
      since= n[0]
      to = n[1]
      Statistic.between(since, to).each do |s|
        last = result.last
        sum = last == nil ? nil : (last + s)
        if(sum == nil) then
          result << s
        else
          result[(result.count) - 1] = sum
        end
      end
      result << nil
      index += 1
    end
    result
  end

  def Statistic.between(m_since, m_to)
    m_since = "since >= \"#{m_since.strftime "%Y-%m-%dT%H:%M:%S.000000+02:00"}\""
    m_to = "\"to\" <= \"#{m_to.strftime "%Y-%m-%dT%H:%M:%S.999999+02:00"}\""
    statement = "SELECT * FROM \"periods\" INNER JOIN \"statistics\" ON periods.id = statistics.period_id WHERE #{mSince} AND #{mTo}"
    adapter = DataMapper.repository(:default).adapter
    (adapter.select statement).map do|row|
      since = Period.parse row[1]
      to = Period.parse row[2]
      period = Period.new since: since, to: to, no_load: true
      temperature = row[4]
      daily_consumption = row[5]
      night_consumption = row[6]
      daily_cost = row[7]
      night_cost = row[8]
      Statistic.new(
        period: period,
        temperature: temperature,
        daily_consumption: daily_consumption,
        night_consumption: night_consumption,
        daily_cost: daily_cost,
        night_cost: night_cost
      )
    end    
  end

  def initialize(params)
    attribute_set :temperature, (params[:temperature])
    attribute_set :daily_consumption, (params[:daily_consumption])
    attribute_set :night_consumption, (params[:night_consumption])
    attribute_set :daily_cost, (params[:daily_cost])
    attribute_set :night_cost, (params[:night_cost])
    self.period = params[:period]
  end

  def inspect
    to_s
  end


  def +(other)
    return nil if other == nil
    if(total_period other) then
      params = {
        period: total_period(other),
        temperature: average_temperature(other),
        daily_consumption: daily_consumption + other.daily_consumption,
        night_consumption: night_consumption + other.night_consumption,
        daily_cost: daily_cost + other.daily_cost,
        night_cost: night_cost + other.night_cost
      }

      return Statistic.new params
    else
      return nil
    end
  end

  def == other
    (!!other) &&
    period == other.period &&
    temperature == other.temperature &&
    daily_consumption == other.daily_consumption &&
    night_consumption == other.night_consumption &&
    daily_cost == other.daily_cost &&
    night_cost == other.night_cost
  end

  def consumption
    (daily_consumption + night_consumption).round 3
  end

  def cost
    (daily_cost + night_cost).round 3
  end

  def to_s
    "Statistic #{period.to_s} temperature #{temperature}" +
    " daily consumption #{daily_consumption}" +
    " night consumption #{night_consumption}" +
    " daily cost #{daily_cost} night cost #{night_cost}"
  end

private

  def total_period(other)
    period + other.period
  end

  def average_temperature(other)
    (temperature * period.length + other.temperature * other.period.length) /
      ((period + other.period).length)
  end

end
