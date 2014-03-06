# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos6.3-puppet3.4.3"
  config.vm.box_url = "https://dl.dropboxusercontent.com/s/l3itm2u66dxc0rm/centos6.3-puppet3.4.3.box?dl=1&token_hash=AAFhtq_yOM4dc_MU1GVY69IOhUgL-tQIHfFs792THGfPlQ"
  config.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
  end

  #Forward the Bounce port
  config.vm.network "forwarded_port", guest: 27080, host: 27080
end
