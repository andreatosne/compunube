#!/bin/bash
set -e

echo "[INFO] Instalando LXD..."
sudo apt-get update -y
sudo apt-get install -y lxd

echo "[INFO] Inicializando LXD con configuración automática..."
sudo lxd init --auto

echo "[INFO] Lanzando contenedor..."
sudo lxc launch images:ubuntu/20.04 webserver

echo "[INFO] Esperando a que el contenedor inicie..."
sleep 15

echo "[INFO] Instalando Apache dentro del contenedor..."
sudo lxc exec webserver -- apt-get update -y
sudo lxc exec webserver -- apt-get install -y apache2

echo "[INFO] Creando página personalizada"
sudo lxc exec webserver -- bash -c 'echo "<h1>Hola! Este es mi sitio web personalizado en LXD</h1>" > /var/www/html/index.html'

echo "[INFO] Redireccionando puerto 8080 del host hacia el contenedor..."
sudo lxc config device add webserver myport80 proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:80

echo "[INFO] Sitio web listo en http://127.0.0.1:8080"
