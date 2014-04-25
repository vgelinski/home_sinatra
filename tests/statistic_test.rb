require './src/model/statistic.rb'
require './tests/test.rb'

since = Time.new
to = since + 60

period = Period.new since: since, to: to

params = {
  period: period,
  temperature: 18,
  daily_consumption: 0.16,
  night_consumption: 0.32,
  daily_cost: 0.4,
  night_cost: 0.8 
}

statistic = Statistic.new params

middle = since + 30
period1 = Period.new since: since, to: middle
period2 = Period.new since: middle, to: to

params = {
  period: period1,
  temperature: 9,
  daily_consumption: 0.04,
  night_consumption: 0.08,
  daily_cost: 0.1,
  night_cost: 0.2 
}

statistic1 = Statistic.new params

params = {
  period: period2,
  temperature: 27,
  daily_consumption: 0.12,
  night_consumption: 0.24,
  daily_cost: 0.3,
  night_cost: 0.6 
}

statistic2 = Statistic.new params

Test.ok(period, statistic.period)
Test.ok(18, statistic.temperature)
Test.ok(0.48, statistic.consumption)
Test.ok(0.16, statistic.daily_consumption)
Test.ok(0.32, statistic.night_consumption)
Test.ok(1.2, statistic.cost)
Test.ok(0.4, statistic.daily_cost)
Test.ok(0.8, statistic.night_cost)
Test.ok(period, (statistic1 + statistic2).period, "period of sum")
Test.ok(18, (statistic1 + statistic2).temperature, "temp of sum")
Test.ok(0.48, (statistic1 + statistic2).consumption, "consumption of sum")
Test.ok(0.16, (statistic1 + statistic2).daily_consumption, "consumption of sum")
Test.ok(0.32, (statistic1 + statistic2).night_consumption)
Test.ok(1.2, (statistic1 + statistic2).cost, "cost of sum")
Test.ok(0.4, (statistic1 + statistic2).daily_cost)
Test.ok(0.8, (statistic1 + statistic2).night_cost)
Test.ok(statistic, statistic1 + statistic2)
Test.ok(nil, statistic + statistic1)
Test.ok(nil, statistic2 + statistic1)
Test.ok(nil, statistic + statistic)
Test.ok(true, statistic == (statistic1 + statistic2))
Test.ok(false, statistic == nil)
