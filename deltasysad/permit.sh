#!/bin/bash

# Replace <directory_path> with the desired directory path
directory_path="/home/neelesh2004/deltasysad/"

# Read roll numbers from student_details.txt and process each one
while IFS= read -r roll_number
do
    # Remove leading/trailing whitespace from the roll number
    roll_number="${roll_number#"${roll_number%%[![:space:]]*}"}"
    roll_number="${roll_number%"${roll_number##*[![:space:]]}"}"

    if [ -n "$roll_number" ]; then
        # Set username based on the roll number
        user_name="student_$roll_number"

        # Set ownership and permissions for the directory
        chown "$user_name:$user_name" "$directory_path"
        chmod 700 "$directory_path"

        echo "Permissions set up successfully for user '$user_name' in directory '$directory_path'!"
    fi
done < student_details.txt

# Reload Bash configuration
source ~/.bashrc

echo "Bash configuration reloaded."

