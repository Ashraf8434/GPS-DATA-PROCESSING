#!/bin/bash

# Read the file line by line
while read -r line; do
  # Extract the first column (date) and the rest of the line from column 7 onwards
  date=$(echo "$line" | awk '{print $1}')
  rest=$(echo "$line" | cut -d ' ' -f 7-)

  # Extract the year, month, and day
  year=$(echo $date | cut -c 1-4)
  month=$(echo $date | cut -c 5-6)
  day=$(echo $date | cut -c 7-8)

  # Convert the date to "Day of the year"
  day_of_year=$(date -d "$year-$month-$day" +%j)
  
   day_of_year=$(date -d "$year-$month-$day" +%j)/365
  # Combine the year and the day of the year
  new_date="$year.$day_of_year"

  # Print the new date and the rest of the line from column 7 onwards
  echo "$new_date $rest"
  
done < SYBC.pos > sybc_extracted.txt
