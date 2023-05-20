#!/bin/bash

# Set the path to the feeBreakup.txt file
fee_breakup_file="admin:///home/neelesh2004/deltasysad/fee_breakup.txt"

# Set the path to the fees.txt file
fees_file="admin:///home/neelesh2004/deltasysad/fees_files/fee.txt"

# Read the student's roll number
read -p "Enter your roll number: " roll_number

# Read the fee breakup details from feeBreakup.txt
while IFS=' ' read -r category percentage; do
    # Calculate the amount based on the percentage
    amount=$(awk "BEGIN {printf \"%.2f\", $percentage/100 * $total_fee}")

    # Update the fees.txt file with the category and amount
    echo "$category: $amount" >> "$fees_file"

    # Update the total fee
    total_fee=$(awk "BEGIN {printf \"%.2f\", $total_fee - $amount}")
done < "$fee_breakup_file"

# Update the total fee at the top of fees.txt
sed -i "1s/.*/Total Fee: $total_fee/" "$fees_file"

echo "Fee payment successful."

