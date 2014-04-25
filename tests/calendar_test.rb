require './tests/test.rb'
require './src/util/calendar.rb'

calendar = Calendar.new

Test.ok([
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 31, 00),
  Time.local(2012, 01, 01, 12, 32, 00),
  Time.local(2012, 01, 01, 12, 33, 00),
  Time.local(2012, 01, 01, 12, 34, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 30, 00),
    Time.local(2012, 01, 01, 12, 34, 00),
    :minute
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 32, 00),
  Time.local(2012, 01, 01, 12, 34, 00),
  Time.local(2012, 01, 01, 12, 36, 00),
  Time.local(2012, 01, 01, 12, 38, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 30, 00),
    Time.local(2012, 01, 01, 12, 38, 00),
    :two_minutes
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 35, 00),
  Time.local(2012, 01, 01, 12, 40, 00),
  Time.local(2012, 01, 01, 12, 43, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 01, 12, 43, 00),
    :five_minutes
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 25, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 35, 00),
  Time.local(2012, 01, 01, 12, 40, 00),
  Time.local(2012, 01, 01, 12, 45, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 25, 00),
    Time.local(2012, 01, 01, 12, 45, 00),
    :five_minutes
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 40, 00),
  Time.local(2012, 01, 01, 12, 50, 00),
  Time.local(2012, 01, 01, 12, 53, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 01, 12, 53, 00),
    :ten_minutes
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 20, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 12, 40, 00),
  Time.local(2012, 01, 01, 12, 50, 00),
  Time.local(2012, 01, 01, 13, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 20, 00),
    Time.local(2012, 01, 01, 13, 00, 00),
    :ten_minutes
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 13, 00, 00),
  Time.local(2012, 01, 01, 13, 30, 00),
  Time.local(2012, 01, 01, 13, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 01, 13, 33, 00),
    :half_hour
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 00, 00),
  Time.local(2012, 01, 01, 12, 30, 00),
  Time.local(2012, 01, 01, 13, 00, 00),
  Time.local(2012, 01, 01, 13, 30, 00),
  Time.local(2012, 01, 01, 14, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 00, 00),
    Time.local(2012, 01, 01, 14, 00, 00),
    :half_hour
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 13, 00, 00),
  Time.local(2012, 01, 01, 14, 00, 00),
  Time.local(2012, 01, 01, 15, 00, 00),
  Time.local(2012, 01, 01, 15, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 01, 15, 33, 00),
    :hour
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 00, 00),
  Time.local(2012, 01, 01, 13, 00, 00),
  Time.local(2012, 01, 01, 14, 00, 00),
  Time.local(2012, 01, 01, 15, 00, 00),
  Time.local(2012, 01, 01, 16, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 00, 00),
    Time.local(2012, 01, 01, 16, 00, 00),
    :hour
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 14, 00, 00),
  Time.local(2012, 01, 01, 16, 00, 00),
  Time.local(2012, 01, 01, 18, 00, 00),
  Time.local(2012, 01, 01, 18, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 01, 18, 33, 00),
    :two_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 00, 00),
  Time.local(2012, 01, 01, 14, 00, 00),
  Time.local(2012, 01, 01, 16, 00, 00),
  Time.local(2012, 01, 01, 18, 00, 00),
  Time.local(2012, 01, 01, 20, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 00, 00),
    Time.local(2012, 01, 01, 20, 00, 00),
    :two_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 01, 18, 00, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 02, 06, 00, 00),
  Time.local(2012, 01, 02, 06, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 02, 06, 33, 00),
    :six_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 00, 00),
  Time.local(2012, 01, 01, 18, 00, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 02, 06, 00, 00),
  Time.local(2012, 01, 02, 12, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 00, 00),
    Time.local(2012, 01, 02, 12, 00, 00),
    :six_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 02, 12, 00, 00),
  Time.local(2012, 01, 03, 00, 00, 00),
  Time.local(2012, 01, 03, 00, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 03, 00, 33, 00),
    :twelve_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 00, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 02, 12, 00, 00),
  Time.local(2012, 01, 03, 00, 00, 00),
  Time.local(2012, 01, 03, 12, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 00, 00),
    Time.local(2012, 01, 03, 12, 00, 00),
    :twelve_hours
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 03, 00, 00, 00),
  Time.local(2012, 01, 04, 00, 00, 00),
  Time.local(2012, 01, 04, 06, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 04, 06, 33, 00),
    :day
  )
)

Test.ok([
  Time.local(2012, 01, 01, 00, 00, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01, 03, 00, 00, 00),
  Time.local(2012, 01, 04, 00, 00, 00),
  Time.local(2012, 01, 05, 00, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 00, 00, 00),
    Time.local(2012, 01, 05, 00, 00, 00),
    :day
  )
)

Test.ok([
  Time.local(2012, 01, 01, 12, 28, 00),
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01,  9, 00, 00, 00),
  Time.local(2012, 01, 16, 00, 00, 00),
  Time.local(2012, 01, 16, 06, 33, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 01, 12, 28, 00),
    Time.local(2012, 01, 16, 06, 33, 00),
    :week
  )
)

Test.ok([
  Time.local(2012, 01, 02, 00, 00, 00),
  Time.local(2012, 01,  9, 00, 00, 00),
  Time.local(2012, 01, 16, 00, 00, 00),
  Time.local(2012, 01, 23, 00, 00, 00),
  Time.local(2012, 01, 30, 00, 00, 00)
  ],
  calendar.each(
    Time.local(2012, 01, 02, 00, 00, 00),
    Time.local(2012, 01, 30, 00, 00, 00),
    :week
  )
)

Test.ok([
  Time.local(2011, 12, 03, 12, 28, 00),
  Time.local(2012, 01, 01, 00, 00, 00),
  Time.local(2012, 02, 01, 00, 00, 00),
  Time.local(2012, 03, 01, 00, 00, 00),
  Time.local(2012, 03, 16, 06, 33, 00)
  ],
  calendar.each(
    Time.local(2011, 12, 03, 12, 28, 00),
    Time.local(2012, 03, 16, 06, 33, 00),
    :month
  )
)

Test.ok([
  Time.local(2011, 12, 01, 00, 00, 00),
  Time.local(2012, 01, 01, 00, 00, 00),
  Time.local(2012, 02, 01, 00, 00, 00),
  Time.local(2012, 03, 01, 00, 00, 00),
  Time.local(2012, 04, 01, 00, 00, 00)
  ],
  calendar.each(
    Time.local(2011, 12, 01, 00, 00, 00),
    Time.local(2012, 04, 01, 00, 00, 00),
    :month
  )
)
