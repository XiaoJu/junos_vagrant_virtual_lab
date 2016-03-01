# -*- mode: ruby -*-
# vi: set ft=ruby :

# Forked from https://keepingitclassless.net/2015/03/go-go-gadget-networking-lab/
# which is forked from https://github.com/JNPRAutomate/vagrant-junos.git
# which uses Juniper box: https://atlas.hashicorp.com/Juniper
# Command to install the required plugins: 
#       vagrant plugin install vagrant-junos
#       vagrant plugin install vagrant-host-shell

# To provision and test JunOS first you have to add the ssh vagrant ssh key into the ssh-agent. I.e.:
#     ssh-add /opt/vagrant/embedded/gems/gems/vagrant-1.8.1/keys/vagrant

# ge-0/0/0.0 defaults to NAT for SSH + management connectivity
# over Vagrant's forwarded ports.  This should configure ge-0/0/1.0
# through ge-0/0/7.0 on VirtualBox.

# provision_junos(port, username, password)

# provision script must have permissions:
#      chmod +x myscript
#      read permissions

# logins and passwords:
# root/Juniper
# vagrant/vagrant

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require "vagrant-host-shell"
require "vagrant-junos"

mynodes=[
    {
    :hostname => "router3",
    # :box => "juniper/ffp-12.1X47-D20.7-packetmode",
    :box => "juniper/ffp-12.1X47-D15.4-packetmode",
    :ram => 512,
    :cpus => 2,
    # :scripts_folder => "./"
    :myscripts => [
        {
            :script_name => "provision01_router3.sh"
        },
        {
            :script_name => "provision02_all.sh"
        }
    ],
    :interfaces => [
        {
            :subnet_name => "3-to-6",
            :subnet_ip => "172.23.10.13"
        },
        {
            :subnet_name => "3-to-4",
            :subnet_ip => "172.23.3.13"
        },
        {
            :subnet_name => "exit3",
            :subnet_ip => "10.10.2.13"
        }
    ]
  #   },
  #   {
  #   :hostname => "router6",
  #   :box => "juniper/ffp-12.1X47-D15.4-packetmode",
  #   :ram => 512,
  #   :cpus => 2,
  #   # :scripts_folder => "./"
  #   :myscripts => [
  #       {
  #           :script_name => "provision01_router6.sh"
  #       },
  #       {
  #           :script_name => "provision02_all.sh"
  #       }
  #   ],
  #   :interfaces => [
  #       {
  #           :subnet_name => "4-to-6",
  #           :subnet_ip => "172.23.7.16"
  #       },
  #       {
  #           :subnet_name => "3-to-6",
  #           :subnet_ip => "172.23.10.16"
  #       }
  #   ]
  # },
  # {
  #   :hostname => "router4",
  #   :box => "juniper/ffp-12.1X47-D15.4-packetmode",
  #   :ram => 512,
  #   :cpus => 2,
  #   # :scripts_folder => "./"
  #   :myscripts => [
  #       {
  #           :script_name => "provision01_router4.sh"
  #       },
  #       {
  #           :script_name => "provision02_all.sh"
  #       }
  #   ],
  #   :interfaces => [
  #       {
  #           :subnet_name => "3-to-4",
  #           :subnet_ip => "172.23.3.14"
  #       },
  #       {
  #           :subnet_name => "4-to-6",
  #           :subnet_ip => "172.23.7.14"
  #       },
  #       {
  #           :subnet_name => "exit4",
  #           :subnet_ip => "10.5.0.14"
  #       }
  #   ]
    }
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box_check_update = false
    mynodes.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]

            node.vm.provider "virtualbox" do |vb|
                vb.check_guest_additions = false
                vb.customize ["modifyvm", :id, "--memory", machine[:ram], "--cpus", machine[:cpus]]
            end

            # assign ip addresses to interfaces
            machine[:interfaces].each do |subnet|
                node.vm.network "private_network",
                            autoconfig: false,
                            ip: subnet[:subnet_ip],
                            virtualbox__intnet: subnet[:subnet_name]
            end

            # provision each node
            machine[:myscripts].each do |script|
                node.vm.provision "file",
                              source: script[:script_name], 
                              destination: '/tmp/' + script[:script_name]
                node.vm.provision :host_shell do |my_host_shell|
                              my_host_shell.inline = 'vagrant ssh router3 -c "/usr/sbin/cli -f /tmp/provision01_router3.sh"'
                end
            end
        end
    end
end
