#!/bin/bash

# Function to measure time to reach "result":"2"
measure_time() {
    local script=$1
    local start_time=$(date +%s%3N)  # Record start time in milliseconds

    while true; do
        output=$($script 2>/dev/null)  # Suppress progress output
        if [[ "$output" == *"\"result\":\"2\""* ]]; then
            local end_time=$(date +%s%3N)  # Record end time in milliseconds
            local elapsed=$((end_time - start_time))
            echo "Time to reach 'result:2' for $script: ${elapsed}ms"
            break
        fi
        sleep 0.1  # Optional delay between checks to avoid excessive looping
    done
}

# Start the process
./ran_start.sh

# Measure time for each script
measure_time "./get_cu_status.sh"
measure_time "./get_hiphy_status.sh"
measure_time "./get_duipc_status.sh"
measure_time "./get_du_status.sh"
