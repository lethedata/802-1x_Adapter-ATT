# 802.1x Bridge Adapter (ATT)

This script creates a 3 port Linux bridge allowing 802.1x authentication to be offloaded from one device (ie router) to a separate device (the bridge).

Note: This script was written for use on Void Linux.

## Usage
1) Modify 802-1x_att.sh variables
2) replace all lines in rc.local with path to script
3) Disable ipv6 via kernel flag ipv6.disable=1
4) Disable dhcpcd, sshd, and ntpd services


## Q&A
- Recommended install?
  - Install to `/opt/att` with certs and wpa_suppicant.conf placed in a subfolder.
- Does the bridge handle MAC Spoofing?
  - No, devices placed behind the bridge still require MAC spoofing.
- Why 3 ports?
  - Three ports enables easy swapping between active-passive devices using the same MAC address.
- Why disable ssh?
  - The bridge device will not receive an IP address and basically acts completely transparent. The idea is to setup the bridge and never touch it.
- Can I add additional lines to rc.conf?
  - Technically yes however be careful not to add commands that conflict with the script.
