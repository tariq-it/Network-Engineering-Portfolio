# 2026-09-04 07:46:16 by RouterOS 7.20.8
# system id = fvEdr/J4hqM
#
/interface bridge
add name=BR-LAN vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/port
set 0 name=serial0
/interface bridge port
add bridge=BR-LAN frame-types=admit-only-vlan-tagged interface=ether1
add bridge=BR-LAN frame-types=admit-only-untagged-and-priority-tagged \
    interface=ether2 pvid=30
add bridge=BR-LAN frame-types=admit-only-untagged-and-priority-tagged \
    interface=ether3 pvid=10
/interface bridge vlan
add bridge=BR-LAN tagged=ether1 untagged=ether2 vlan-ids=30
add bridge=BR-LAN tagged=ether1 untagged=ether3 vlan-ids=10
add bridge=BR-LAN tagged=ether1 vlan-ids=20
/ip address
add address=192.168.233.202/24 comment=MANAGEMENT interface=ether4 network=\
    192.168.233.0
/ip dhcp-client
# DHCP client can not run on slave or passthrough interface!
add interface=ether1
/system identity
set name=MT-SW2
