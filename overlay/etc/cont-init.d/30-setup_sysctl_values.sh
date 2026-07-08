#!/usr/bin/env bash

print_header "Configure sysctl parameters"

if [ "$(cat /proc/sys/vm/max_map_count)" -lt 524288 ]; then
    if [ -w "/proc/sys/vm/max_map_count" ]; then
        print_note "Setting the maximum number of memory map areas a process can create to 524288"
        echo 524288 > /proc/sys/vm/max_map_count
    else
        print_warning "Unable to set vm.max_map_count on unprivileged container"
    fi
else
    print_note "The vm.max_map_count is already greater than or equal to '524288'"
fi

print_done
