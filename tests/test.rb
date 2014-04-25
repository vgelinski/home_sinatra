require 'data_mapper'

#require all models

Dir["./src/model/*.rb"].each { |file| require file}

DataMapper::Logger.new $stdout, :debug
DataMapper.setup :default, "sqlite:db/test.db"
DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!


class Test
  def Test.ok(expected, actual, string = nil)
    success = (expected == actual)
    if success then
      puts "\033[42mok\033[0m"
      return
    else
      puts "\033[41mfailed"
      puts string if string
      puts "Expected #{expected.inspect}, Actual #{actual.inspect}"
      puts caller.join "\n"
      puts "\033[0m"
    end
  end
end

