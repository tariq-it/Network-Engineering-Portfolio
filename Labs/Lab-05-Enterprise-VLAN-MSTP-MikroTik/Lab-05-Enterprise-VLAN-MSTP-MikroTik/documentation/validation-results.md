# Validation Results

## 1. Department Segmentation

VLANs 10, 20, 30, 40 and 99 were successfully carried across the trunk infrastructure.

## 2. DHCP

Validated leases included:

- Administration client: `192.168.10.200`
- IT1: `192.168.20.200`
- IT2: `192.168.20.199`
- Finance client: `192.168.30.200`

## 3. DNS and Internet

MikroTik DNS forwarding was enabled with `allow-remote-requests=yes`.

Clients successfully resolved and reached public destinations such as:

```text
google.com
8.8.8.8
```

## 4. Security Policy

Sales validation:

```text
ping 192.168.99.14   -> failed
ping 192.168.20.200  -> failed
ping 8.8.8.8         -> successful
ping google.com      -> successful
```

This confirms internal isolation while retaining Internet access.

## 5. IT Management Access

IT clients successfully reached VLAN 99 and remotely managed the Cisco switches using PuTTY.

Example:

```text
IT client -> 192.168.99.14 -> SW4-IT
```

## 6. Layer 3 Path Validation

Traceroute from IT toward the Internet showed:

```text
1  192.168.20.1
2  192.168.233.2
```

Traceroute from IT toward SW4 management showed:

```text
1  192.168.20.1
2  192.168.99.14
```

Layer 2 Cisco switch hops do not appear in traceroute.

## 7. MSTP Normal State

Before failure on SW4:

```text
##### MST1    vlans mapped:   10,20,30,40,99
Root          address aabb.cc00.5000
              port    Et0/1
              cost    4000000

Interface        Role Sts Cost
Et0/0            Altn BLK 10000000
Et0/1            Root FWD 2000000
Et0/2            Desg FWD 2000000
Et0/3            Desg FWD 2000000
```

## 8. MSTP Failover

`Et0/1` on SW4 was shut down while IT1 continuously pinged `8.8.8.8`.

Post-failover state:

```text
##### MST1    vlans mapped:   10,20,30,40,99
Bridge        address aabb.cc00.8000  priority 32769
Root          address aabb.cc00.5000  priority 24577
              port Et0/0 cost 10020000 rem hops 18

Interface        Role Sts Cost
Et0/0            Root FWD 10000000
Et0/2            Desg FWD 2000000
Et0/3            Desg FWD 2000000
```

The alternate path became the root forwarding path and client Internet connectivity recovered in approximately one second.

## 9. Restore Test

After `Et0/1` was restored:

```text
Et0/0  Altn BLK
Et0/1  Root FWD
```

The spanning-tree roles were correct. A stale dynamic MAC/FDB condition was observed in the virtual lab after reconvergence; clearing the dynamic MAC address table restored traffic.
