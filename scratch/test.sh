#!/bin/bash

net_info="$(ifconfig)"
address="$(echo "$net_info" | grep inet)"

echo -e "IP addresses on this compputer are:\n$address"