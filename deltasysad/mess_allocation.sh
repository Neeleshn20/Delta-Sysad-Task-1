#!/bin/bash

# Read the user's role as an argument
role=$1

# Set the path to the userDetails.txt file
user_details_file="admin:///home/neelesh2004/deltasysad/student_details.txt"

# Set the path to the mess.txt file
mess_file="admin:///home/neelesh2004/deltasysad/student_details.txt"

# Set the path to the roll numbers file
roll_numbers_file="admin:///home/neelesh2004/deltasysad/rollNumbers.txt"

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

