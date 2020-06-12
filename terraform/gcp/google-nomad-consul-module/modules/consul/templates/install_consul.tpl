#!/usr/bin/env sh
#consul bootstrap script

systemctl -q stop firewalld
systemctl -q disable firewalld

set -ex

install_consul() {

yum install -q -y wget unzip yum-utils
wget https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip -O /tmp/consul.zip
unzip /tmp/consul.zip -d /usr/local/bin/
consul --version

}

configure_consul(){

useradd --system --home /etc/consul.d --shell /bin/false consul

cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/usr/local/bin/consul reload
ExecStop=/usr/local/bin/consul leave
KillMode=process
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

mkdir --parents /etc/consul.d

cat <<EOF > /etc/consul.d/consul.hcl
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "Luj2FZWwlt8475wD1WtwUQ=="
retry_join = ["${internal_ip}"]

EOF

chmod 640 /etc/consul.d/consul.hcl
chown --recursive consul:consul /etc/consul.d

mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul

systemctl -q daemon-reload
systemctl -q enable consul.service

}


configure_consul_server(){

cat <<EOF > /etc/consul.d/server.hcl
server = true
bootstrap_expect = ${num_nodes}
ui = true
client_addr = "0.0.0.0"
EOF

chmod 640 /etc/consul.d/server.hcl
chown --recursive consul:consul /etc/consul.d

}
start_consul(){
  systemctl -q start consul.service
}

install_consul
configure_consul
configure_consul_server
start_consul

echo "done"