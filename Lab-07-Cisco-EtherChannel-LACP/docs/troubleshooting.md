# Troubleshooting Notes

## Initial LACP State
Before SW2 was configured for LACP, SW1 showed Po1 down and the physical members suspended. This is expected because an LACP active interface needs a compatible LACP peer.

After SW2 was configured in passive mode, both switches showed:

```text
Po1(SU)  LACP  Et0/0(P) Et0/1(P) Et0/2(P)
```

## Spanning Tree Verification
SW1 was the STP root for VLAN 10. Po1 was forwarding on both switches:
- SW1: Po1 Designated / Forwarding
- SW2: Po1 Root / Forwarding

This confirmed that STP treated the EtherChannel as one logical interface.

## Member-Link Failure Observation
With all three links bundled, Et0/0 was administratively shut down on SW1 while continuous ICMP traffic was running.

Observed state:
```text
Po1(SU)  LACP  Et0/0(D) Et0/1(P) Et0/2(P)
```

The logical Port-Channel stayed up and two members remained bundled, but the ICMP flow did not recover until Et0/0 was restored. This is not the expected production EtherChannel failover behavior and is recorded as an IOL/EVE-NG emulation observation.

No false claim of successful failover is made in this lab.
