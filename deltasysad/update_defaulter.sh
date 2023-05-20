#!/bin/bash

# Read the hostel name as an argument
hostel=$1

# Set the path to the fee files directory
fee_files_dir="admin://#!/bin/bash

# Read the user's role as an argument
role=$1

# Set the path to the userDetails.txt file
user_details_file="/path/to/userDetails.txt"

# Set the path to the mess.txt file
mess_file="/path/to/mess.txt"

# Set the path to the roll numbers file
roll_numbers_file="/path/to/rollNumbers.txt"

# Function to record mess preferences for a student
record_mess_preferences() {
    # Read the student's roll number
    read -p "Enter your roll number: " roll_number

    # Read and validate the mess preference order
    read -p "Enter your mess preference order as a numeric sequence (e.g., 1,2,3): " mess_preferences

    # Validate the mess preference order
    if ! [[ $mess_preferences =~ ^[0-9]+(,[0-9]+)*$ ]]; then
        echo "Invalid mess preference order. Please try again."
        return 1
    fi

    # Update the mess preferences in userDetails.txt
    sed -i "/^Roll Number: $roll_number$/,/^$/ s/^Mess Preferences: .*/Mess Preferences: $mess_preferences/" "$user_details_file"

    # Append the roll number to the mess.txt file
    echo "$roll_number" >> "$mess_file"

    echo "Mess preferences recorded successfully."
}

# Function to allocate messes to students
allocate_messes() {
    # Read the mess capacity from the top of mess.txt
    mess_capacity=$(sed -n '1p' "$mess_file")

    # Read the roll numbers from mess.txt
    roll_numbers=$(tail -n +2 "$mess_file")

    # Loop through the roll numbers and allocate messes
    for roll_number in $roll_numbers; do
        # Read the mess preference order from userDetails.txt
        mess_preferences=$(grep -A1 "^Roll Number: $roll_number$" "$user_details_file" | grep "Mess Preferences:" | cut -d ':' -f 2 | tr -d ' ')

        # Find the first available mess based on preference order
        allocated_mess=""
        IFS=',' read -ra preferences <<< "$mess_preferences"
        for preference in "${preferences[@]}"; do
            # Check if the preference is within the mess capacity and not already allocated
            if [[ $preference -le $mess_capacity && ! $(grep -q "$preference" "$roll_numbers_file") ]]; then
                allocated_mess=$preference
                break
            fi
        done

        # If a mess is allocated, update the roll_numbers.txt file
        if [[ -n $allocated_mess ]]; then
            echo "$roll_number" >> "$roll_numbers_file"
        fi
    done

    echo "Mess allocation completed successfully."
}

# Check the user's role and perform the corresponding action
if [[ $role == "student" ]]; then
    record_mess_preferences
elif [[ $role == "hostel_office" ]]; then
    allocate_messes
else
    echo "Invalid role. Please specify either 'student' or 'hostel_office'."
fi
/home/neelesh2004/deltasysad/fee_files"

# Set the path to the feeDefaulters.txt file
defaulter_file="admin:///home/neelesh2004/deltasysad/HostelWarden/FeeDefaulters.txt"

# Set the path to the announcements.txt file
announcements_file="admin:///home/neelesh2004/deltasysad/HostelWarden/announcements.txt"
# Read the fee files for all students in the hostel
for file in "$fee_files_dir/$hostel"/*; do
    # Extract the name and roll number from the file name
    name=$(basename "$file" .txt)
    roll_number=$(grep -oP '^Roll Number:\s*\K.+' "$file")

    # Check if the fee is paid before the end of the semester
    # Modify this condition as per your requirement
    if grep -q "Fee Paid" "$file"; then
        continue  # Fee is paid, skip to the next student
    fi

    # Add an entry to the feeDefaulters.txt file
    echo "Name: $name, Roll Number: $roll_number" >> "$defaulter_file"
done

# Retrieve the names and roll numbers of the first 5 students who paid fees
paid_students=$(grep -l "Fee Paid" "$fee_files_dir/$hostel"/*)
first_five_students=$(head -n 5 "$paid_students" | cut -d ':' -f 1,2)

# Append the roll numbers to the announcements.txt file
echo "Roll numbers of first 5 students who paid fees: $first_five_students" >> "$announcements_file"
