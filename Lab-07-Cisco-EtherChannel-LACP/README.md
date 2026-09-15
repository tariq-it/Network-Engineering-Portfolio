# Lab 07 - Cisco EtherChannel (LACP)

## Overview
This lab demonstrates a Layer 2 EtherChannel between two Cisco switches using LACP. Three physical Ethernet links are bundled into a single logical Port-Channel and configured as an 802.1Q trunk.

## Topology
- SW1 and SW2 connected with three physical links:
  - Et0/0 <-> Et0/0
  - Et0/1 <-> Et0/1
  - Et0/2 <-> Et0/2
- Win1 connected to SW1 Et0/3
- Win2 connected to SW2 Et0/3
- Port-Channel: Po1
- Protocol: LACP
- VLAN 10: ADMIN
- VLAN 20: IT

## Addressing
| Device | IP Address | VLAN |
|---|---|---|
| Win1 | 192.168.10.10/24 | 10 |
| Win2 | 192.168.10.20/24 | 10 |

No default gateway is required because both test hosts are in the same subnet.

## LACP Design
SW1 is configured in LACP `active` mode and SW2 in `passive` mode. The three member links form Port-Channel 1. Po1 is configured as a trunk carrying the configured VLANs.

Successful verification showed:

`Po1(SU)  LACP  Et0/0(P) Et0/1(P) Et0/2(P)`

- `S` - Layer 2
- `U` - Port-Channel in use
- `P` - Physical interface bundled in the Port-Channel

## Verification
The lab verified:
- LACP negotiation between active and passive peers
- All three physical interfaces bundled into Po1
- Po1 operating as an 802.1Q trunk
- VLAN 10 connectivity between Win1 and Win2
- Spanning Tree treating Po1 as one logical interface

## Failover Test
A member-link shutdown test was also performed. In the IOL/EVE-NG environment used for this lab, Po1 remained `SU` and the remaining links remained bundled, but the active ICMP flow did not successfully fail over when Et0/0 was shut down. Connectivity returned when Et0/0 was restored.

This behavior is documented as an emulation/environment troubleshooting observation rather than presented as a successful redundancy test. In a correctly operating EtherChannel, traffic should be redistributed across the remaining active member links.

## Useful Commands
```text
show etherchannel summary
show etherchannel port-channel
show interfaces status
show spanning-tree vlan 10
show interfaces trunk
show mac address-table
```

## Key Takeaways
EtherChannel combines multiple physical links into one logical link, increasing available aggregate bandwidth and providing link redundancy. LACP dynamically negotiates membership and helps ensure compatible links are bundled. Configuration consistency across member interfaces and both peers is essential.

## Repository Structure
```text
Lab-07-Cisco-EtherChannel-LACP/
├── README.md
├── configs/
│   ├── SW1.txt
│   └── SW2.txt
├── docs/
│   └── troubleshooting.md
└── screenshots/
```
