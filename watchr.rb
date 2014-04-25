
watch("tests/period_test.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("tests/test.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("tests/statistic_test.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("tests/calendar_test.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("watchr.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/model/period.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/model/statistic.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/model/.period.rb.swp") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/util/calendar.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/util/device_manager.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/util/settings.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/util/ticker.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("src/util/.calendar.rb.swp") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

watch("main.rb") do
  system "clear"
  system "./tests/run_all_tests.sh"
end

