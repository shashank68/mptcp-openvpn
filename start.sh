#!/bin/bash
set -x

shopt -s expand_aliases
alias netex="ip netns exec"

./setup_topology.sh

# sleep 5
netex h2 openvpn --daemon --config ./openvpn_conf/server.conf
sleep 1
netex h1 openvpn --daemon --config ./openvpn_conf/vpn1.conf
sleep 1
netex h1 openvpn --daemon --config ./openvpn_conf/vpn2.conf
sleep 1


ip -n h1 rule add pref 10 from 11.0.0.2 table isp1
ip -n h1 route add default via 11.0.0.1 dev h1_s_a table isp1

ip -n h1 rule add pref 10 from 11.0.0.3 table isp2
ip -n h1 route add default via 11.0.0.1 dev h1_s_b table isp2


ip -n h2 mptcp endpoint flush
ip -n h2 mptcp limits set subflow 2 add_addr_accepted 2

ip -n h1 mptcp endpoint flush
ip -n h1 mptcp limits set subflow 2 add_addr_accepted 2
ip -n h1 mptcp endpoint show
ip -n h1 route show
ip -n h1 mptcp endpoint add 10.0.0.12 dev tun2 id 1 subflow

ip -n h1 rule add pref 10 from 10.0.0.11 table vpn1
ip -n h1 route add default dev tun1 table vpn1

ip -n h1 rule add pref 10 from 10.0.0.12 table vpn2
ip -n h1 route add default  dev tun2 table vpn2

echo "Ensure that the below entries are present in /etc/iproute2/rt_tables 
101 isp1
102 isp2
11 vpn1
12 vpn2"
