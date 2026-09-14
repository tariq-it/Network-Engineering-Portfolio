# Lab 05 - MikroTik RouterOS
# Cleaned/reconstructed config matching the validated final lab state.
# WAN ether1 obtains 192.168.233.134/24 dynamically in the EVE/VMware environment.

# Bridge
/interface bridge
add name=BR-LAN protocol-mode=mstp vlan-filtering=yes

/interface bridge port
add bridge=BR-LAN interface=ether2
add bridge=BR-LAN interface=ether3
add bridge=BR-LAN interface=ether4
add bridge=BR-LAN interface=ether5

# VLAN interfaces
/interface vlan
add interface=BR-LAN name=VLAN10-ADMIN vlan-id=10
add interface=BR-LAN name=VLAN20-IT vlan-id=20
add interface=BR-LAN name=VLAN30-FINANCE vlan-id=30
add interface=BR-LAN name=VLAN40-SALES vlan-id=40
add interface=BR-LAN name=VLAN99-MGMT vlan-id=99

# Tagged VLANs on all downstream trunks
/interface bridge vlan
add bridge=BR-LAN tagged=BR-LAN,ether2,ether3,ether4,ether5 vlan-ids=10
add bridge=BR-LAN tagged=BR-LAN,ether2,ether3,ether4,ether5 vlan-ids=20
add bridge=BR-LAN tagged=BR-LAN,ether2,ether3,ether4,ether5 vlan-ids=30
add bridge=BR-LAN tagged=BR-LAN,ether2,ether3,ether4,ether5 vlan-ids=40
add bridge=BR-LAN tagged=BR-LAN,ether2,ether3,ether4,ether5 vlan-ids=99

# Gateways
/ip address
add address=192.168.10.1/24 interface=VLAN10-ADMIN
add address=192.168.20.1/24 interface=VLAN20-IT
add address=192.168.30.1/24 interface=VLAN30-FINANCE
add address=192.168.40.1/24 interface=VLAN40-SALES
add address=192.168.99.1/24 interface=VLAN99-MGMT

# DHCP pools
/ip pool
add name=pool-ADMIN ranges=192.168.10.100-192.168.10.200
add name=pool-IT ranges=192.168.20.100-192.168.20.200
add name=pool-FINANCE ranges=192.168.30.100-192.168.30.200
add name=pool-SALES ranges=192.168.40.100-192.168.40.200

/ip dhcp-server
add address-pool=pool-ADMIN interface=VLAN10-ADMIN lease-time=8h name=DHCP-ADMIN
add address-pool=pool-IT interface=VLAN20-IT lease-time=8h name=DHCP-IT
add address-pool=pool-FINANCE interface=VLAN30-FINANCE lease-time=8h name=DHCP-FINANCE
add address-pool=pool-SALES interface=VLAN40-SALES lease-time=8h name=DHCP-SALES

/ip dhcp-server network
add address=192.168.10.0/24 dns-server=192.168.10.1 gateway=192.168.10.1
add address=192.168.20.0/24 dns-server=192.168.20.1 gateway=192.168.20.1
add address=192.168.30.0/24 dns-server=192.168.30.1 gateway=192.168.30.1
add address=192.168.40.0/24 dns-server=192.168.40.1 gateway=192.168.40.1

# DNS forwarding
/ip dns
set allow-remote-requests=yes

# NAT to WAN
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade comment="WAN-MASQUERADE"

# Stateful firewall policy
/ip firewall filter
add chain=forward connection-state=established,related action=accept comment="ALLOW-ESTABLISHED-RELATED"
add chain=forward src-address=192.168.20.0/24 action=accept comment="ALLOW-IT-TO-ALL"
add chain=forward src-address=192.168.10.0/24 dst-address=192.168.0.0/16 action=drop comment="BLOCK-ADMIN-TO-INTERNAL"
add chain=forward src-address=192.168.30.0/24 dst-address=192.168.0.0/16 action=drop comment="BLOCK-FINANCE-TO-INTERNAL"
add chain=forward src-address=192.168.40.0/24 dst-address=192.168.0.0/16 action=drop comment="BLOCK-SALES-TO-INTERNAL"

# WAN
/ip dhcp-client
add interface=ether1 disabled=no
