#!/usr/bin/env bash
#nomad bootstrap script

systemctl -q stop firewalld
systemctl -q disable firewalld

set -ex

install_nomad() {

  yum install -q -y wget unzip yum-utils

  wget https://releases.hashicorp.com/nomad/0.11.2/nomad_0.11.2_linux_amd64.zip -O /tmp/nomad.zip
  unzip /tmp/nomad.zip -d /usr/bin/

  nomad version

}

configure_nomad() {

  cat <<EOF >/etc/systemd/system/nomad.service
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF

  mkdir --parents /etc/nomad.d
  chmod 700 /etc/nomad.d

  cat <<EOF >/etc/nomad.d/nomad.hcl
datacenter = "dc1"
data_dir = "/opt/nomad"
EOF

  mkdir --parents /opt/nomad
  chmod 700 /opt/nomad

  systemctl -q daemon-reload
  systemctl -q enable nomad.service
}

configure_nomad_server() {

  cat <<EOF >/etc/nomad.d/server.hcl
server {
  enabled = true
  bootstrap_expect = ${num_nodes}
}
EOF

}

configure_nomad_client() {
  cat <<EOF >/etc/nomad.d/client.hcl
client {
  enabled = true
}
EOF
}

start_nomad() {
  systemctl -q start nomad.service
}

install_consul() {

  yum install -q -y wget unzip
  wget https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip -O /tmp/consul.zip
  unzip /tmp/consul.zip -d /usr/bin/
  consul --version

}

configure_consul() {

  useradd --system --home /etc/consul.d --shell /bin/false consul

  cat <<EOF >/etc/systemd/system/consul.service
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
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
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

  cat <<EOF >/etc/consul.d/consul.hcl
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "Luj2FZWwlt8475wD1WtwUQ=="
EOF

  chmod 640 /etc/consul.d/consul.hcl
  chown --recursive consul:consul /etc/consul.d

  mkdir --parents /opt/consul
  chown --recursive consul:consul /opt/consul

  systemctl -q daemon-reload
  systemctl -q enable consul.service

}

configure_consul_client() {

  cat <<EOF >/etc/consul.d/client.hcl
server = false
ui = true
client_addr = "0.0.0.0"
start_join = ["${consul_server}"]
EOF

  chmod 640 /etc/consul.d/client.hcl
  chown --recursive consul:consul /etc/consul.d

}

start_consul() {
  systemctl -q start consul.service
}

install_docker() {

  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

  yum install -q -y docker-ce docker-ce-cli containerd.io
  systemctl -q enable docker
  systemctl -q start docker
}

install_nomad
configure_nomad

if [[ "${is_server}" == "true" ]]; then
  configure_nomad_server
else
  configure_nomad_client
fi

start_nomad

install_consul
configure_consul
configure_consul_client
start_consul

if [[ "${is_server}" == "true" ]]; then
  exit 0
else
  install_docker
fi

echo "done"
