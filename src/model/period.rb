require 'data_mapper'
require 'time'

class Period

  include DataMapper::Resource

  property :id, Serial
  property :since, Time
  property :to, Time

  has 1, :statistic

  def Period.between(m_since, m_to)
    m_since = "since >= \"#{m_since.strftime "%Y-%m-%dT%H:%M:%S.000000+02:00"}\""
    m_to = "\"to\" <= \"#{m_to.strftime "%Y-%m-%dT%H:%M:%S.999999+02:00"}\""
    adapter = Period.new({}).adapter
    statement = "SELECT * FROM \"periods\" WHERE #{m_since} AND #{m_to}"
    rows = adapter.select statement
    rows.map do |row|
      id = row[0]
      since = parse row[1]
      to = parse row[2]
      Period.new id: id, since: since, to: to, no_load: true
    end
  end

  def initialize(params)
    attribute_set(:id, params[:id])
    attribute_set(:since, params[:since])
    attribute_set(:to, params[:to])
    #@since, @to = params[:since], params[:to]
    @loaded = false
    if(!params[:no_load]) then
      loadd
    end
  end

  def loadd
     return nil if (id == nil)

     statement = "SELECT \"since\" FROM \"periods\" WHERE id=#{id}"
     date_string = (adapter.select statement)[0]
     @since = Period.parse date_string
     attribute_set :since, @since

     statement = "SELECT \"to\" FROM \"periods\" WHERE id=#{id}"
     date_string = (adapter.select statement)[0]
     @to = Period.parse date_string
     attribute_set :to, @to
     @loaded = true
     puts "Period #{id} loaded"
     self
  end

  def adapter
    repository.adapter
  end

  def since
   if(!@loaded & saved?) then
     statement = "SELECT \"since\" FROM \"periods\" WHERE id=#{id}"
     date_string = (adapter.select statement)[0]
     Period.parse date_string
   else
     super
   end
   #@since
  end


  def to
   if(!@loaded & saved?) then
     statement = "SELECT \"to\" FROM \"periods\" WHERE id=#{id}"
     date_string = (adapter.select statement)[0]
     Period.parse date_string
   else
     super
   end
   #@to
  end

  def Period.parse(date_string)
     return nil unless date_string
     year = (date_string.split '-')[0]
     month = (date_string.split '-')[1]
     day = ((date_string.split '-')[2].split 'T')[0]
     hour = ((date_string.split 'T')[1].split ':')[0]
     minute = ((date_string.split 'T')[1].split ':')[1]
     second = ((date_string.split '.')[0].split ':')[2]
     t = Time.local year, month, day, hour, minute, second
  end

  def since=(since_param)
    unless(@to != nil && @to.to_i < since_param.to_i) then
      @since = since_param
      super since_param
    end
  end

  def to=(to_param)
    unless(@since != nil && @since.to_i > to_param.to_i) then
      @to = to_param
      super to_param
    end
  end

  def length
    l = to.to_i - since.to_i
    #puts "shkembence #{l}"
    l
  end

  def + other
    other && to == other.since ? Period.new(since: since, to: other.to) : nil
  end

  def == other
    other != nil && since.to_i == other.since.to_i && to.to_i == other.to.to_i
  end

  def to_s
    "Period: since #{since} to #{to}"
  end
end
