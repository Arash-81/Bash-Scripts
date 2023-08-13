#!/bin/bash

ping_count=5
db_host="localhost"
db_port="5432"
db_name="network"
db_user="postgres"
db_pass=$(cat /home/arash/Desktop/task1/dbPass)

function getPing() {
    ping -c $ping_count $1 > domain_info
    packet_loss=$(awk -v count="$ping_count" 'NR == (count + 4) {print $6}' domain_info | sed 's/%//')
    avg_ping=$(awk -v count="$ping_count" 'NR == (count + 5) {print $4}' domain_info | cut -d'/' -f2)
    min_ping=$(awk -v count="$ping_count" 'NR == (count + 5) {print $4}' domain_info | cut -d'/' -f1)
    max_ping=$(awk -v count="$ping_count" 'NR == (count + 5) {print $4}' domain_info | cut -d'/' -f3)
    jitter=$(echo "$max_ping - $min_ping" | bc)
    ip=$(awk 'NR == 1 {print $3}' domain_info | sed 's/[()]//g')

    PGPASSWORD="$db_pass" psql -h $db_host -p $db_port -U $db_user -d $db_name << EOF
    INSERT INTO domain_info (domain_name, ip_address, jitter, packet_loss, avg_ping_time)
    VALUES ('$1', '$ip', $jitter, $packet_loss, $avg_ping);
EOF
    echo "inserted $1 $ip"
}

while getopts "c:d:f:" opt; do
    case $opt in    
    c)
        ping_count="$OPTARG"
        ;;
    d) 
        domain="$OPTARG"
        getPing $domain
        ;; 
    f) 
        file="$OPTARG"
        while IFS= read -r line
        do
            getPing $line
        done < "$file"
        ;;
    *) 
        echo "invalid option"
        exit 1
        ;;
    esac

done
rm -f domain_info