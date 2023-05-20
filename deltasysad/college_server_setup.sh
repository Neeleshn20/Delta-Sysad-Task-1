#!/bin/bash

create_user() {
    local name=$1
    local roll_number=$2
    local hostel=$3
    local room=$4
    local mess=$5
    local mess_preferences="${@:6}"

    # Create user
    useradd -m -s /bin/bash "$name"

    # Set password
    echo "$name:$roll_number" | chpasswd

    echo "User '$name' created successfully!"
}

process_student_file() {
    local filename=$1

    if [[ ! -f $filename ]]; then
        echo "File '$filename' not found."
        return
    fi

    while IFS=' ' read -r name roll_number hostel room mess rest_of_fields; do
        # Extract mess preferences
        IFS=' ' read -r -a mess_preferences <<< "$rest_of_fields"

        if [[ -n $name && -n $roll_number && -n $hostel && -n $room && -n $mess ]]; then
            create_user "$name" "$roll_number" "$hostel" "$room" "$mess" "${mess_preferences[@]}"
        else
            echo "Invalid line format: $name $roll_number $hostel $room $mess $rest_of_fields"
        fi
    done < "$filename"
}

# Function to create a directory if it doesn't exist
create_directory() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

# Function to create a file if it doesn't exist
create_file() {
  if [ ! -f "$1" ]; then
    touch "$1"
  fi
}

# Function to set up permissions for files and directories
set_permissions() {
  chown -R "$1" "$2"
  chmod -R "$3" "$2"
}
# Example usage of processing the student details file
process_student_file "/home/neelesh2004/deltasysad/student_details.txt"

