
# PKI System setup for Openvpn

```bash
./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-client-full vpn1 nopass
./easyrsa build-client-full vpn2 nopass
./easyrsa build-server-full vps nopass
```