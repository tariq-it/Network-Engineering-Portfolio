# Troubleshooting Notes — Inter-LAN ICMP

## Symptom

Clients received DHCP correctly and could communicate inside their own LAN, but a ping initiated from STAFF (`192.168.20.11`) to OFFICE (`192.168.10.11`) timed out.

## What Was Verified

### 1. Layer 3 Interfaces

- port2 / OFFICE-LAN: `192.168.10.1/24`
- port3 / STAFF-LAN: `192.168.20.1/24`
- Both interfaces were UP/RUNNING with no RX/TX errors or drops.

### 2. Routing

FortiGate routing table contained:

```text
S* 0.0.0.0/0 via 192.168.233.2, port1
C  192.168.10.0/24 directly connected, port2
C  192.168.20.0/24 directly connected, port3
C  192.168.233.0/24 directly connected, port1
```

### 3. ARP

FortiGate successfully learned both destination hosts:

```text
192.168.20.11  50:00:00:07:00:00  port3
192.168.10.11  50:00:00:03:00:00  port2
```

### 4. Endpoint Reachability

After enabling Windows ICMPv4 Echo Request inbound rules:

- FortiGate -> `192.168.10.11`: success
- FortiGate -> `192.168.20.11`: success
- Same-LAN host-to-host ping: success

### 5. Firewall Policy

Policy 1 was configured as STAFF-to-OFFICE, ACCEPT, ALL services, NAT disabled.

Compiled policy inspection showed:

```text
policy index=1 action=accept
zone(1): 5 -> zone(1): 4
source: 0.0.0.0-255.255.255.255
dest:   0.0.0.0-255.255.255.255
```

Interface indexes observed:

- port3 = 5
- port2 = 4

### 6. Packet Sniffer

A sniffer for traffic between `192.168.20.11` and `192.168.10.11` observed ICMP echo requests arriving on port3, but no corresponding `port2 out` packet was observed.

### 7. Debug Flow

Filtered debug flow repeatedly showed:

```text
received a packet ... 192.168.20.11 -> 192.168.10.11 from port3
allocate a new session
DNAT: no-match
find a route ... gw-192.168.10.11 via port2
```

The trace stopped after route lookup; it did not show the expected forward-policy acceptance/egress stage.

### 8. Offload Test

`auto-asic-offload` was temporarily disabled on policy 1 and sessions were cleared. The behavior remained unchanged.

## Conclusion

The basic lab objectives — multiple FortiGate LANs, DHCP, client addressing, local LAN connectivity, routing visibility, and firewall-policy configuration — were completed successfully.

The remaining STAFF-to-OFFICE ICMP forwarding issue was not resolved during this EVE-NG session. It is retained here as a troubleshooting record rather than presenting the lab as fully successful.
