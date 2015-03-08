# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define :bitrix do |bx_config|
        bx_config.vm.box = "precise32"
        bx_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
        bx_config.ssh.forward_agent = true
        
        # This will give the machine a static IP uncomment to enable
        bx_config.vm.network :private_network, ip: "192.168.56.101"
        
        bx_config.vm.network :forwarded_port, guest: 80, host: 8888, auto_correct: true
        bx_config.vm.network :forwarded_port, guest: 3306, host: 8889, auto_correct: true
        bx_config.vm.network :forwarded_port, guest: 5432, host: 5433, auto_correct: true
        #bx_config.vm.network :forwarded_port, guest: 1080, host: 10080, auto_correct: true

        bx_config.vm.hostname = "dev.local"
        #bx_config.hostsupdater.aliases = ["alias.testing.de", "alias2.somedomain.com"]

        # Use NFS for shared folders for better performance
        bx_config.vm.synced_folder "www", "/var/www", nfs: true
        
        #bx_config.vm.synced_folder "www", "/var/www", {:mount_options => ['dmode=777','fmode=777']}
        #bx_config.vm.synced_folder "db", "/var/lib/mysql", {:mount_options => ['dmode=777','fmode=777']}
        bx_config.vm.provision :shell, :inline => "echo \"Europe/Moscow\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

        bx_config.vm.provider :virtualbox do |v|

            host = RbConfig::CONFIG['host_os']

            if host =~ /darwin/
                cpus = `sysctl -n hw.ncpu`.to_i
                # sysctl returns Bytes and we need to convert to MB
                mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
            elsif host =~ /linux/
                cpus = `nproc`.to_i
                # meminfo shows KB and we need to convert to MB
                mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
            else # sorry Windows folks, I can't help you
                cpus = 2
                mem = 1024
            end

            v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            v.customize ["modifyvm", :id, "--ioapic", "on"]    
            v.customize ["modifyvm", :id, "--memory", mem]
            v.customize ["modifyvm", :id, "--cpus", cpus]
        
        end



        bx_config.vm.provision :puppet do |puppet|
            puppet.manifests_path = "puppet/manifests"
            puppet.manifest_file  = "phpbase.pp"
            puppet.module_path = "puppet/modules"
            #puppet.options = "--verbose --debug"
        end

        bx_config.vm.provision :shell, :path => "puppet/scripts/enable_remote_mysql_access.sh"
    end
end
