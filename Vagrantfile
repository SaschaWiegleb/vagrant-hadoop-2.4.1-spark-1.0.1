Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"
IP_SUBNET_ADRESS="192.168.0"
MEMORY="3072"
CPUS="4"
#more than 1 node
NUM_NODES = 3

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	r = NUM_NODES..1
	(r.first).downto(r.last).each do |i|
		#vagrant login as root by default
		config.ssh.username = 'root'
		config.ssh.password = 'vagrant'
		config.ssh.insert_key = true
		config.vm.define "node#{i}" do |node|
			node.vm.box = "centos65"
			node.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
			if i == 1
				node.vm.provider "virtualbox" do |v|
					v.name = "node#{i}"
					#http://vl4rl.com/2014/06/04/enabling-mulitcpu-vagrant-machines/
					v.customize ["modifyvm", :id, "--ioapic", "on"  ]
	    			v.customize ["modifyvm", :id, "--cpus"  , "2"]
	    			v.customize ["modifyvm", :id, "--memory", "1536"]
				end
			else
				node.vm.provider "virtualbox" do |v|
					v.name = "node#{i}"
					#http://vl4rl.com/2014/06/04/enabling-mulitcpu-vagrant-machines/
					v.customize ["modifyvm", :id, "--ioapic", "on"  ]
	    			v.customize ["modifyvm", :id, "--cpus"  , "#{CPUS}"]
	    			v.customize ["modifyvm", :id, "--memory", "#{MEMORY}"]
				end
			end
			if i < 10
				node.vm.network :private_network, ip: "#{IP_SUBNET_ADRESS}.10#{i}"
			elsif i < 100
				node.vm.network :private_network, ip: "#{IP_SUBNET_ADRESS}.10#{i}"
			else
				node.vm.network :private_network, ip: "#{IP_SUBNET_ADRESS}.#{i}"
			end
			node.vm.hostname = "node#{i}"
			node.vm.provision "shell", path: "scripts/setup-centos.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-centos-hosts.sh"
				s.args = "-t #{NUM_NODES}"
			end
			if i == 1
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 2 -t #{NUM_NODES}"
				end
			end
			node.vm.provision "shell", path: "scripts/setup-java.sh"
			node.vm.provision "shell", path: "scripts/setup-hadoop.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-hadoop-slaves.sh"
				s.args = "-s 2 -t #{NUM_NODES}"
			end
			node.vm.provision "shell", path: "scripts/setup-spark.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-spark-slaves.sh"
				s.args = "-s 2 -t #{NUM_NODES}"
			end
			if i == 1
				node.vm.provision "shell", path: "scripts/init-start-all-services.sh"
			end
		end
	end
end