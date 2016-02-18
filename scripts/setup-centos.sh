#!/bin/bash
source "/vagrant/scripts/common.sh"

function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}

function changeTimezone {
	echo "changing timezone"
	cp /etc/localtime /root/old.timezone
	rm -f /etc/localtime
	ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
}

echo "setup centos"

disableFirewall
changeTimezone