#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalJava {
	echo "install oracle jdk from local file"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteJava {
	echo "install oracle jdk from remote file"
	curl -vs -o /vagrant/resources/$JAVA_ARCHIVE -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_MIRROR_DOWNLOAD >/dev/null 2>&1
	tar -xzf /vagrant/resources/$JAVA_ARCHIVE -C /usr/local
	#yum install -y java-1.7.0-openjdk.x86_64
}

function setupJava {
	echo "setting up java"
	if resourceExists $JAVA_ARCHIVE; then
		ln -s /usr/local/jdk$JAVA_VERSION /usr/local/java
	else
		ln -s /usr/lib/jvm/jre /usr/local/java
	fi
}

function setupEnvVars {
	echo "creating java environment variables"
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
}

function installJava {
	if resourceExists $JAVA_ARCHIVE; then
		installLocalJava
	else
		installRemoteJava
	fi
}

echo "setup java"
installJava
setupJava
setupEnvVars