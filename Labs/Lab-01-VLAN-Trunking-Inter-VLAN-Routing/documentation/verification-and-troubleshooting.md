# Verification and Troubleshooting

## Switch Verification

### Confirm VLAN Creation and Port Membership

```text
show vlan brief
```

Expected result:

- Ethernet0/1 belongs to VLAN 10.
- Ethernet0/2 belongs to VLAN 20.
- Ethernet0/3 belongs to VLAN 30.

### Confirm the Trunk

```text
show interfaces trunk
```

Expected result:

- Ethernet0/0 operates as an 802.1Q trunk.
- VLANs 10, 20, and 30 are allowed and forwarding.

### Confirm the Management SVI

```text
show ip interface brief
show interfaces Vlan20
```

Expected result:

- VLAN 20 uses `192.168.20.2/24` for switch management.
- The SVI is up when VLAN 20 is active and at least one associated port is operational.

## Router Verification

### Confirm Subinterfaces

```text
show ip interface brief
show interfaces Ethernet0/0.10
show interfaces Ethernet0/0.20
show interfaces Ethernet0/0.30
```

Expected result:

- All three subinterfaces are up/up.
- Each subinterface uses the correct 802.1Q VLAN tag.
- Each gateway address belongs to the correct subnet.

### Confirm Connected Routes

```text
show ip route connected
```

Expected connected networks:

```text
192.168.10.0/24
192.168.20.0/24
192.168.30.0/24
```

## Host Connectivity Tests

Run these tests from each Windows host:

```text
ipconfig
ping <local-default-gateway>
ping <host-in-another-vlan>
arp -a
```

Suggested validation matrix:

| Source | Destination | Expected Result |
|---|---|---|
| PC-USERS `192.168.10.10` | R1 `192.168.10.1` | Success |
| PC-USERS `192.168.10.10` | PC-IT `192.168.20.10` | Success |
| PC-USERS `192.168.10.10` | PC-SERVERS `192.168.30.10` | Success |
| PC-IT `192.168.20.10` | PC-SERVERS `192.168.30.10` | Success |
| SW1 `192.168.20.2` | R1 `192.168.20.1` | Success |

## Troubleshooting Checklist

If inter-VLAN communication fails, check the following in order:

1. Confirm the host IP address, subnet mask, and default gateway.
2. Confirm the PC-facing switch port belongs to the intended VLAN.
3. Confirm VLANs 10, 20, and 30 exist and are active.
4. Confirm Ethernet0/0 on SW1 operates as a trunk.
5. Confirm all three VLANs are allowed on the trunk.
6. Confirm the router parent interface and subinterfaces are up.
7. Confirm the 802.1Q VLAN tag on each router subinterface.
8. Confirm the Windows firewall permits ICMP Echo traffic. In an isolated lab only, the firewall may be temporarily disabled for testing.
9. Check ARP entries and repeat the ping after ARP resolution.

