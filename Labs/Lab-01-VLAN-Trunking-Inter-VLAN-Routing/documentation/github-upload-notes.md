# GitHub Upload Notes

## Canonical Portfolio Location

Upload this lab into the existing portfolio at:

```text
Labs/Lab-01-VLAN-Trunking-Inter-VLAN-Routing/
```

All future labs should follow the same standard:

```text
Labs/
└── Lab-XX-Topic-Name/
    ├── README.md
    ├── topology.png
    ├── lab-file.unl
    ├── configurations/
    ├── screenshots/
    ├── documentation/
    └── video/
```

## Root README Lab Row

After the lab files are uploaded and verified, replace the existing Lab 01 row in the portfolio README with:

```markdown
| 01 | [VLAN, Trunking & Inter-VLAN Routing](Labs/Lab-01-VLAN-Trunking-Inter-VLAN-Routing/) | Cisco | VLANs, 802.1Q, Router-on-a-Stick | EVE-NG | Completed |
```

## Recommended Commit Messages

For the lab files:

```text
feat(lab-01): add VLAN and inter-VLAN routing lab
```

For the root README status update:

```text
docs: mark Lab 01 as completed
```

## Before Uploading

- Export the EVE-NG topology and name it `lab-file.unl` if it will be shared.
- Do not upload Cisco IOS/IOL images, Windows images, or other licensed appliance images.
- Do not upload passwords, password hashes, API keys, or production credentials.
- Rename the EVE-NG switch node from `R2` to `SW1` for consistency.
- Apply the final `R1` and `SW1` configurations before capturing final verification output.
- Add the walkthrough video to `video/` only when it is ready.
- Keep large video files below GitHub's file-size limits or host the video externally and link to it from the lab README.

