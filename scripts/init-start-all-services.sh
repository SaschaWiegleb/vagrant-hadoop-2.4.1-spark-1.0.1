#!/bin/bash
source "/vagrant/scripts/common.sh"

function formatNameNode {
	$HADOOP_PREFIX/bin/hdfs namenode -format myhadoop -force -noninteractive
	echo "formatted namenode"
}

function startHDFS {
	$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
	$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
	echo "started hdfs"
}

function startYarn {
	$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
	$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
	$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
	$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
	echo "started yarn"
}

function createEventLogDir {
	hdfs dfs -mkdir /tmp
	hdfs dfs -mkdir /tmp/spark-events
	echo "created spark event log dir"
}

function startSpark {
	$SPARK_HOME/sbin/start-all.sh
	export SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=hdfs://node1:9000/tmp/spark-events"
	$SPARK_HOME/sbin/start-history-server.sh
	echo "started spark"
}

#function changeHdfsPermissions {
#	hdfs dfs -chmod -R 777 /
#	hdfs dfs -chown -R swiegleb /
#	echo "permissions changed"
#}

function copyHdfsFiles {
	echo "copy files to HDFS"
	hadoop fs -copyFromLocal /vagrant/hdfs/* hdfs://node1:9000/
	hadoop fs -copyFromLocal /usr/local/spark/lib/spark-assembly-1.6.0-hadoop2.6.0.jar hdfs://node1:9000/
}

formatNameNode
startHDFS
startYarn
createEventLogDir
startSpark
copyHdfsFiles
#changeHdfsPermissions