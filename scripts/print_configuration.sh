#!/bin/bash

# Function to process each technology block
process_checks() {
    local tech_name=$1
    local main_check_var=$2

    # Get the main check value directly from the environment
    local main_check_value=${!main_check_var}

    # Print the main check
    echo "$tech_name checks: $main_check_value"

    # If main check is true, process its child checks
    if [[ "$main_check_value" == "true" ]]; then
        # Find all environment variables that belong to this technology but exclude the main check variable itself
        for var in $(env | grep "^${main_check_var%_CHECKS}_" | grep -v "^$main_check_var=" | awk -F '=' '{print $1}'); do
            # Extract the child check name (remove the technology prefix and lower case it)
            local child_check_name=$(echo "$var" | sed "s/^${main_check_var%_CHECKS}_//" | tr '[:upper:]' '[:lower:]')
            local child_check_value=${!var}
            echo -e "\t$child_check_name: $child_check_value"
        done
    fi
    echo ""
}

# Loop over all environment variables
for var in $(env | grep -o "^UCI_[A-Z_]*_CHECKS" | sort -u); do
    # Check if it's a main technology check
    if [[ $var =~ ^UCI_([A-Z]+)_CHECKS$ ]]; then
        tech=$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')
        main_check_var="UCI_${BASH_REMATCH[1]}_CHECKS"
        process_checks "$tech" "$main_check_var"
    fi
done
