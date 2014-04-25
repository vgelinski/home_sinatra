require './src/model/period.rb'
require './tests/test.rb'

since = Time.new
to = since + 60

period = Period.new since: since, to: to

before_since = since - 1
after_to = to + 1

middle = since + 30

period1 = Period.new since: since, to: middle
period2 = Period.new since: middle, to: to

Test.ok(since, period.since)
Test.ok(to, period.to)
Test.ok(since, period.since = since, "setting since")
Test.ok(to, period.to = to, "setting to")
Test.ok(since, period.since, "getting since")
Test.ok(to, period.to, "getting to")
Test.ok(after_to, period.since = after_to, "setting illegal since")
Test.ok(before_since, period.to = before_since, "setting illegal to")
Test.ok(since, period.since, "getting since")
Test.ok(to, period.to, "getting to")
Test.ok(to.to_i - since.to_i, period.length)
Test.ok(period, (period1 +  period2))
Test.ok(period.since, (period1 + period2).since)
Test.ok(period.to, (period1 + period2).to)
Test.ok(nil, period + period1)
Test.ok(nil, period2 + period1)
Test.ok(true, period == (period1 + period2))
Test.ok(false, period == nil)

Test.ok(to, period.to)
Test.ok(since, period.since)


#period.save

#Test.ok(true, period.saved?, "Saving period")
#Test.ok(period, Period.first, "Retrieving period")
#Test.ok(true, period.destroy, "Deleting period")
