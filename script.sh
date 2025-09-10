#!/bin/bash

echo "Instalando LXD..."
sudo snap install lxd
sudo lxd init --auto

echo "Creando contenedores..."
lxc launch ubuntu:22.04 web1
lxc launch ubuntu:22.04 web2
lxc launch ubuntu:22.04 haproxy

echo "Esperando que se inicien los contenedores..."
sleep 15

echo "Configurando servidores web..."
# web1
lxc exec web1 -- apt update
lxc exec web1 -- apt install -y apache2
lxc exec web1 -- bash -c "echo 'Hola desde web1' > /var/www/html/index.html"
lxc exec web1 -- systemctl restart apache2

# web2
lxc exec web2 -- apt update
lxc exec web2 -- apt install -y apache2
lxc exec web2 -- bash -c "echo 'Hola desde web2' > /var/www/html/index.html"
lxc exec web2 -- systemctl restart apache2

echo "Configurando HAProxy..."
lxc exec haproxy -- apt update
lxc exec haproxy -- apt install -y haproxy

# Configurar HAProxy CORRECTAMENTE con las IPs REALES
lxc exec haproxy -- bash -c "cat > /etc/haproxy/haproxy.cfg << 'EOF'
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    server web1 10.213.211.5:80 check
    server web2 10.213.211.47:80 check

listen stats
    bind *:1936
    stats enable
    stats uri /
    stats hide-version
EOF"

lxc exec haproxy -- systemctl restart haproxy

echo "Exponiendo puerto 8080..."
# Primero remover si ya existe
lxc config device remove haproxy webproxy 2>/dev/null || true
lxc config device add haproxy webproxy proxy \
    listen=tcp:0.0.0.0:8080 \
    connect=tcp:127.0.0.1:80

echo "Prueba con: http://localhost:8080"