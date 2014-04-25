ls ./tests/*_test.rb |cat| while read file
do
  echo "$file"
  ruby $file
done
