# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest:22, host: 2221, id: 'ssh'
  config.vm.network "forwarded_port", guest: 8888, host: 8888

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision "shell",
    # we need to run as iruby at least once to install that kernel
    inline: "cd /vagrant && iruby notebook --ip=0.0.0.0 --no-browser",
    run: "always"
end
