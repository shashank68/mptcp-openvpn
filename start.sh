#!/bin/bash

shopt -s expand_aliases
alias netex="ip netns exec"

./setup_topology.sh

ip -n h2 mptcp endpoint flush
ip -n h2 mptcp limits set subflow 2 add_addr_accepted 2

ip -n h1 mptcp endpoint flush
ip -n h1 mptcp limits set subflow 2 add_addr_accepted 2
ip -n h1 mptcp endpoint show
ip -n h1 mptcp endpoint add 11.0.0.3 dev h1_s_b id 1 subflow

echo "Ensure that the below entries are present in /etc/iproute2/rt_tables:
101 isp1
102 isp2
"

ip -n h1 rule add pref 10 from 11.0.0.2 table isp1
ip -n h1 route add default via 11.0.0.1 dev h1_s_a table isp1

ip -n h1 rule add pref 10 from 11.0.0.3 table isp2
ip -n h1 route add default via 11.0.0.1 dev h1_s_b table isp2


