Vagrant.configure("2") do |config|

  # Desactiva la instalación automática de vagrant-vbguest si está presente
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.no_install = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true
  end

  # Máquina cliente
  config.vm.define "clienteUbuntu" do |clienteUbuntu|
    clienteUbuntu.vm.box = "bento/ubuntu-20.04"
    clienteUbuntu.vm.network "private_network", ip: "192.168.100.2"
    clienteUbuntu.vm.hostname = "clienteUbuntu"
  end

  # Máquina servidor
  config.vm.define "servidorUbuntu" do |servidorUbuntu|
    servidorUbuntu.vm.box = "bento/ubuntu-20.04"
    servidorUbuntu.vm.network "private_network", ip: "192.168.100.3"
    servidorUbuntu.vm.provision "shell", path: "script.sh"
servidorUbuntu.vm.network "forwarded_port", guest: 1936, host: 1936

    servidorUbuntu.vm.hostname = "servidorUbuntu"

    # Redirección de puerto 8080 para acceder desde el host (Windows)
     end

end
