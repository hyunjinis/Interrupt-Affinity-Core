#!/bin/bash

limit=10000

bounded_core() {
    cores=$(nproc)
    bounded=""

    interrupt_number=$(grep eth0 /proc/interrupts | awk -F'[: ]+' '{print $1,$2}' | tr -s '\n' ' ')

    for num in $interrupt_number; do
            cores=$(nproc)
                   for (( i=0; i<$cores; i++ )); do
                        core=$((i+2))
                        amount=$(grep "^ *$num:" /proc/interrupts | awk -v core="$core" '{print $core}')
                        if [ ! -z "$amount" ] && [ "$amount" -gt "$limit" ]; then
                                bounded="$bounded $i"
                                break
                        fi
                   done
    done
    echo "Bounded cores: $bounded"
}

bounded_core
