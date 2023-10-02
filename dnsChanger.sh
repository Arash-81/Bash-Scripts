#!/bin/bash

shecan1=178.22.122.100
shecan2=185.51.200.2
google1=8.8.8.8
google2=8.8.4.4
cloudflare1=1.1.1.1
cloudflare2=1.0.0.1
default=127.0.0.53

case $1 in
    g)
        dns1=$google1
        dns2=$google2
        ;;
    sh)
        dns1=$shecan1
        dns2=$shecan2
        ;;
    cf)
        dns1=$cloudflare1
        dns2=$cloudflare2
        ;;
    cfg)
        dns1=$cloudflare1
        dns2=$google1
        ;;    
    def) 
        dns1=$default
        ;;
    *)
        echo "Invalid option: $1"
        exit 1
        ;;
esac

echo "nameserver $dns1" | sudo tee /etc/resolv.conf > /dev/null
if [ -n "$dns2" ]
then
    echo "nameserver $dns2" | sudo tee -a /etc/resolv.conf > /dev/null
fi

echo "DNS changed to $dns1 and $dns2"

cat /etc/resolv.conf