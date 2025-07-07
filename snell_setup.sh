apt update
apt install -y curl unzip

VERSION="5.0.0b2"
PORT=$(( RANDOM % 64512 + 1024 ))
PSK=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 31)

wget -qO snell-server.zip https://dl.nssurge.com/snell/snell-server-v${VERSION}-linux-amd64.zip
unzip snell-server.zip -d /usr/local/bin
chmod +x /usr/local/bin/snell-server
rm snell-server.zip

mkdir /etc/snell
cat > /etc/snell/snell-server.conf << EOF
[snell-server]
listen = 0.0.0.0:$PORT
psk = $PSK
ipv6 = false
EOF

cat > /etc/systemd/system/snell-server.service << EOF
[Unit]
Description=Snell Server Service
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
DynamicUser=true
LimitNOFILE=32768
ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start snell-server
systemctl enable snell-server

IP=$(curl -4 -s ifconfig.me || curl -6 -s ifconfig.me)
echo "Snell_Server = snell,$IP,$PORT,psk=$PSK,version=${VERSION:0:1},tfo=true"
