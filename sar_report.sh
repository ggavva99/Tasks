#!/bin/bash

# Output file for report
REPORT_FILE="/root/sar_report.txt"
LOG_PATH="/var/log/sa"

# Clear any previous report
> "$REPORT_FILE"

# Get today's day of the month
TODAY=$(date +%d)

# Loop from 9th to today (adjust range if needed)
for DAY in $(seq -w 09 "$TODAY"); do
    FILE="$LOG_PATH/sa$DAY"

    # If log file exists
    if [ -f "$FILE" ]; then
        echo "===== Date: June $DAY, 2025 =====" >> "$REPORT_FILE"

        # Check if the date is today
        if [ "$DAY" = "$TODAY" ]; then
            # We are in today, so just report until 2 AM (early morning)
            START1="00:00:00"
            END1="02:00:00"
            echo "--- CPU (00:00 to 02:00) ---" >> "$REPORT_FILE"
            sar -u -s $START1 -e $END1 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Memory (00:00 to 02:00) ---" >> "$REPORT_FILE"
            sar -r -s $START1 -e $END1 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Network (00:00 to 02:00) ---" >> "$REPORT_FILE"
            sar -n DEV -s $START1 -e $END1 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Disk I/O (00:00 to 02:00) ---" >> "$REPORT_FILE"
            sar -d -s $START1 -e $END1 -f "$FILE" >> "$REPORT_FILE" 2>&1

        else
            # For previous days, get 7 PM to midnight and then get 00:00 to 2 AM from the next day's file
            echo "--- CPU (19:00 to 23:59) ---" >> "$REPORT_FILE"
            sar -u -s 19:00:00 -e 23:59:59 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Memory (19:00 to 23:59) ---" >> "$REPORT_FILE"
            sar -r -s 19:00:00 -e 23:59:59 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Network (19:00 to 23:59) ---" >> "$REPORT_FILE"
            sar -n DEV -s 19:00:00 -e 23:59:59 -f "$FILE" >> "$REPORT_FILE" 2>&1

            echo "--- Disk I/O (19:00 to 23:59) ---" >> "$REPORT_FILE"
            sar -d -s 19:00:00 -e 23:59:59 -f "$FILE" >> "$REPORT_FILE" 2>&1

            # Look ahead to next day for 00:00 to 02:00
            NEXT_DAY=$(printf "%02d" $((10#$DAY + 1)))
            NEXT_FILE="$LOG_PATH/sa$NEXT_DAY"

            if [ -f "$NEXT_FILE" ]; then
                echo "--- CPU (00:00 to 02:00) ---" >> "$REPORT_FILE"
                sar -u -s 00:00:00 -e 02:00:00 -f "$NEXT_FILE" >> "$REPORT_FILE" 2>&1

                echo "--- Memory (00:00 to 02:00) ---" >> "$REPORT_FILE"
                sar -r -s 00:00:00 -e 02:00:00 -f "$NEXT_FILE" >> "$REPORT_FILE" 2>&1

                echo "--- Network (00:00 to 02:00) ---" >> "$REPORT_FILE"
                sar -n DEV -s 00:00:00 -e 02:00:00 -f "$NEXT_FILE" >> "$REPORT_FILE" 2>&1

                echo "--- Disk I/O (00:00 to 02:00) ---" >> "$REPORT_FILE"
                sar -d -s 00:00:00 -e 02:00:00 -f "$NEXT_FILE" >> "$REPORT_FILE" 2>&1
            else
                echo "--- Next day's file (for 00:00–02:00) not found: $NEXT_FILE ---" >> "$REPORT_FILE"
            fi
        fi

        echo -e "\n\n" >> "$REPORT_FILE"
    else
        echo "--- sar file missing: $FILE ---" >> "$REPORT_FILE"
    fi
done

echo "Report saved to $REPORT_FILE"
