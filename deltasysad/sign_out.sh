#!/bin/bash

# Set the path to the warden approval file
warden_approval_file="admin:///home/neelesh2004/deltasysad/warden_approval.txt"

# Set the path to the student return file
student_return_file="admin:///home/neelesh2004/deltasysad/student_return.txt"

# Read the student's roll number as an argument
roll_number=$1

# Read the warden's approval for overnight stay
read -p "Warden approval for overnight stay (yes/no): " approval

# Check if the approval is "yes"
if [ "$approval" = "yes" ]; then
    # Record the return date for the student
    read -p "Enter the return date (YYYY-MM-DD): " return_date

    # Append the student's return date to the student_return.txt file
    echo "$roll_number: $return_date" >> "$student_return_file"

    echo "Approval granted. Return date recorded."
else
    echo "Approval not granted."
fi

