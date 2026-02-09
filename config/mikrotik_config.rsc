# 2026-02-06 12:55:48 by RouterOS 7.20.6
# system id = l4OTU4Vy46B
#
/interface ethernet
set [ find default-name=ether2 ] disable-running-check=no name=ether1
set [ find default-name=ether1 ] disable-running-check=no name=ether2
/ip ipsec profile
add dpd-interval=10s enc-algorithm=aes-256 hash-algorithm=sha256 name=\
    Sophos_Profile
/ip ipsec peer
add address=10.10.10.1/32 exchange-mode=ike2 name=Sophos_Peer profile=\
    Sophos_Profile
/ip ipsec proposal
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc name=Sophos_Proposal \
    pfs-group=modp2048
/port
set 0 name=serial0
/ip address
add address=10.10.10.2/24 interface=ether1 network=10.10.10.0
add address=192.168.88.1/24 interface=ether2 network=192.168.88.0
/ip dhcp-client
add interface=ether1
/ip firewall nat
add action=accept chain=srcnat dst-address=192.168.20.0/24 src-address=\
    192.168.88.0/24
add action=masquerade chain=srcnat out-interface=ether1
/ip ipsec identity
add peer=Sophos_Peer
/ip ipsec policy
add dst-address=192.168.20.0/24 level=unique peer=Sophos_Peer proposal=\
    Sophos_Proposal src-address=192.168.88.0/24 tunnel=yes
/ip route
add dst-address=192.168.20.0/24 gateway=10.10.10.1
