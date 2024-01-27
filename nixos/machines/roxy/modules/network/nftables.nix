{ pkgs, ... }:
let
  # IF_WAN = "dslite";
  IF_WAN = "ppp0";
  IF_WAN6 = "ppp0";
  IF_WELL = "wg-well";
  IF_MULLVAD = "mullvad.150";
  # IF_WAN = "enp1s0";
  IF_MODEM = "enp1s0";
  # IF_LAN = "eth0";
  IF_LAN = "enp2s0";
  IF_ZERO_SSS = "ztbtovjx4h";
  IF_ZERO_PRIV = "ztr2q3arx2";
  LAN_IPS = "192.168.178.0/24";
in
{
  networking.nftables = {
    enable = true;
    flushRuleset = true;
    checkRuleset = true;
    tables = {
      filter = {
        content = ''
          chain input_icmp_untrusted {
            # Allow ICMP echo
            ip protocol icmp icmp type { echo-request, destination-unreachable, time-exceeded } limit rate 1000/second burst 5 packets accept comment "Accept echo request"

            # Allow some ICMPv6
            icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, echo-request, echo-reply, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-done, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, mld2-listener-report } limit rate 1000/second burst 5 packets accept comment "Allow some ICMPv6"
          }

          chain input_wan {
            # DHCPv6 client
            meta nfproto ipv6 udp sport 547 accept comment "Allow DHCPv6 client"

            jump input_icmp_untrusted
          }

          chain input_lan {
            counter accept comment "Accept all traffic from LAN"
          }

          chain input_mullvad {
            # Allow DHCP from Mullvad
            udp dport { 67 } accept comment "Allow DHCP from Mullvad"
          }

          chain input_zero_sss {
            jump input_icmp_untrusted

            tcp dport { 
              22, # SSH
              139, # Samba
              445, # Samba
              2049, # NFS
              7766, # Niketsu
              19999, # Netdata
              8211, # Palworld
            } accept comment "Allow SSH, NFS, Samba and Netdata from ZERO_SSS"
            udp dport { 
              137, # Samba
              138, # Samba
              8211, # Palworld
            } accept comment "Allow Samba from ZERO_SSS"
            counter drop comment "Drop everything else from ZERO_SSS"
          }

          chain input_zero_priv {
            counter accept comment "Accept all traffic from ZERO_PRIV"
          }

          chain input {
            type filter hook input priority filter; policy drop;

            ct state { established, related } counter accept comment "Accept packets from established and related connections"
            ct state invalid counter drop comment "Early drop of invalid packets"

            iifname vmap { 
              lo : accept, 
              ${IF_WAN} : jump input_wan, 
              ${IF_WAN6} : jump input_wan, 
              ${IF_LAN} : jump input_lan, 
              ${IF_MULLVAD} : jump input_mullvad,
              ${IF_ZERO_SSS} : jump input_zero_sss, 
              ${IF_ZERO_PRIV} : jump input_zero_priv 
            }
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            meta nftrace set 1

            # Accept connections tracked by destination NAT
            ct status dnat counter accept comment "Accept connections tracked by DNAT"

            # jump input_icmp_untrusted
            # meta l4proto ipv6-icmp accept comment "Forward ICMP in IPv6"

            # LAN -> WAN
            iifname { ${IF_LAN} } oifname { ${IF_WAN}, ${IF_LAN}, ${IF_WAN6}, ${IF_MODEM} } counter accept comment "Allow all traffic forwarding from LAN to LAN and WAN"

            # WAN -> LAN
            iifname { ${IF_WAN}, ${IF_WAN6}, ${IF_MODEM} } oifname { ${IF_LAN} } ct state { established, related } counter accept comment "Allow established back from WAN"

            # MULLVAD -> WELL
            iifname { ${IF_MULLVAD} } oifname { ${IF_WELL} } counter accept comment "Allow all traffic forwarding from LAN to LAN and WAN"

            # WELL -> MULLVAD
            iifname { ${IF_WELL} } oifname { ${IF_MULLVAD} } ct state { established, related } counter accept comment "Allow established back from WAN"
          }

          chain output {
            type filter hook output priority 100; policy accept;
          }
        '';
        family = "inet";
      };
      nat = {
        content = ''
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;

            ip daddr 15.1.1.1 dnat to 192.168.1.1
          }

          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;

            meta nftrace set 1

            ip saddr { ${LAN_IPS} } oifname { ${IF_MODEM} } masquerade
            ip saddr { 172.16.0.2/12 } oifname { ${IF_WELL} } masquerade
            oifname { ${IF_WAN} } masquerade comment "Masquerade traffic from LANs" # Not required if dslink is used
          }
        '';
        family = "ip";
      };
    };
  };
}
