watchr="watchr.rb"

echo "">$watchr
find|cat|grep .rb|grep -v svn| while read file
do
  #Removin leading "./"
  file=`echo "$file"|sed -r 's/^.{2}//'`

  echo "watch(\"$file\") do">>$watchr
  echo "  system \"clear\"">>$watchr
  echo "  system \"./tests/run_all_tests.sh\"">>$watchr
  echo "end">>$watchr
  echo "">>$watchr
done
