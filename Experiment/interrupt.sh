#!/bin/bash

result=$(sshpass -p oslab1slab ssh -o StrictHostKeyChecking=no orin@192.168.0.70 "bash -s" < bounded_core.sh)

bounded=$(echo "$result" | awk '/Bounded cores:/ {for (i=3; i<=NF; i++) print $i}' | xargs)
others=""

total=$(sshpass -p oslab1slab ssh -o StrictHostKeyChecking=no orin@192.168.0.70 "nproc")

for core in $(seq 0 $((total-1))); do
    if [[ ! " $bounded " =~ " $core " ]]; then
        if [ -z "$others" ]; then
            others="$core"
        else
            others="$others,$core"
        fi
    fi
done

others=$(echo "$others" | tr -d ' ' | sed 's/,/, /g')

echo "Bounded cores: $bounded"
echo "Other cores: $others"

pkt=1024

mkdir hjkim/interrupt/orin/none/${pkt}
echo $pkt

random_core=$(echo "${others}" | tr ',' '\n' | shuf | head -n 1 |  tr -d ' ')
echo "Selected cores: ${random_core}"


kubectl exec -it p1 --namespace=default -- taskset -c "${random_core}" netperf -H 192.168.0.3 -p 12865 -l 600 -- -m "${pkt}" &

sleep 5

for k in $(seq 1 12)
        do

                kubectl exec -it p1 --namespace=default -- taskset -c "${random_core}" vnstat -tr 10 |awk '/tx/' |awk '{print $2,$4}' >> hjkim/interrupt/orin/none/${pkt}/vnstat.txt&
                sshpass -p oslab1slab ssh -o StrictHostKeyChecking=no orin@192.168.0.70 "pidstat -G netperf 1 10" >> hjkim/interrupt/orin/none/${pkt}/pidstat_netperf.txt&
                kubectl exec -it p1 --namespace=default -- taskset -c "${random_core}" mpstat -P ALL 10 1 |awk '/Average/' >> hjkim/interrupt/orin/none/${pkt}/mpstat_cpu.txt
                sleep 3
done

sshpass -p oslab1slab ssh -o StrictHostKeyChecking=no orin@192.168.0.70 sudo killall netperf

sleep 1
