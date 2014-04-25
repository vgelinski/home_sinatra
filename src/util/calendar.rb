class Calendar

  Second = 1
  Minute = 60 * Second
  HalfHour = 30 * Minute
  Hour = 60 * Minute
  Day = 24 * Hour
  Week = 7 * Day

  def each(from, to, interval)
    case interval
      when :minute
        each_minute from, to
      when :two_minutes
        each_two_minutes from, to
      when :five_minutes
        each_five_minutes from, to
      when :ten_minutes
        each_ten_minutes from, to
      when :half_hour
        each_half_hour from, to
      when :hour
        each_hour from, to
      when :two_hours
        each_two_hours from, to
      when :six_hours
        each_six_hours from, to
      when :twelve_hours
        each_twelve_hours from, to
      when :day
        each_day from, to
      when :week
        each_week from, to
      when :month
        each_month from, to
      else
        []
    end 
  end 




  private

  def each_minute(from, to)
    current = from
    result = []
    while (current <= to) do
      result << current
      current += Minute
    end

    result
  end

  def each_two_minutes(from, to)
    current = from
    result = []
    while (current <= to) do
      result << current
      current += 2 * Minute
    end

    result
  end

  def each_five_minutes(from, to)
    first = from - from.sec - (from.min % 5) * 60 + 5 * Minute
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += 5 * Minute
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_ten_minutes(from, to)
    first = from - from.sec - (from.min % 10) * 60 + 10 * Minute
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += 10 * Minute
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_half_hour(from, to)
    first = from - from.sec - (from.min % 30) * 60 + HalfHour
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += HalfHour
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_hour(from, to)
    first = from - from.sec - (from.min) * 60 + Hour
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += Hour
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_two_hours(from, to)
    first = from - from.sec - (from.min) * 60 - (from.hour % 2)*Hour + 2 * Hour
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += 2 * Hour
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_six_hours(from, to)
    first = from - from.sec - (from.min) * 60 - (from.hour % 6)*Hour + 6 * Hour
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += 6 * Hour
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_twelve_hours(from, to)
    first = from - from.sec - (from.min) * 60 - (from.hour % 12)*Hour + 12 * Hour
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += 12 * Hour
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_day(from, to)
    first = from - from.sec - (from.min) * Minute - (from.hour) * Hour + Day
    current = first
    result = []
    result << from
    while (current <= to) do
      result << current
      current += Day
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_week(from, to)
    sec, min, hour,wday = from.sec, from.min, from.hour, from.wday
    wday = wday == 0 ? 7 : wday
    first = from - sec - min*60 - hour*Hour - (wday - 1)*Day + Week
    current = first
    result = []
    result << from unless first == from
    while (current <= to) do
      result << current
      current += Week
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end

  def each_month(from, to)
    year, month, day = from.year, from.month, from.day
    date = (Date.new year, month, day) >> 1
    first = Time.local date.year, date.month, 1, 0, 0, 0
    current = first
    result = []
    result << from unless first == from
    while (current <= to) do
      result << current
      year, month, day = current.year, current.month, current.day
      date = Date.new year, month, day
      date = date >> 1
      year,month, day = date.year, date.month, date.day
      current = Time.local year, month, 1, 0, 0, 0
    end
    to_added = result.last == to
    result << to unless to_added

    result
  end
end
