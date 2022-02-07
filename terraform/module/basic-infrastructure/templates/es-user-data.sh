#!/bin/bash -x

yum update -y

# AWS logs
yum install -y awslogs

cat > /etc/awslogs/awscli.conf <<- EOF
[default]
region = ${aws_region}
[plugins]
cwlogs = cwlogs

EOF

cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/cloud-init.log]
datetime_format = %b %d %H:%M:%S
file = /var/log/cloud-init.log
log_stream_name = {instance_id}/var/log/cloud-init.log
log_group_name = ${log_group_name}

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log
log_stream_name = {instance_id}/var/log/cloud-init-output.log
log_group_name = ${log_group_name}

[/var/log/clouda-jenkins-backup.log]
file = /var/log/clouda-jenkins-backup.log
log_stream_name = {instance_id}/var/log/clouda-jenkins-backup.log
log_group_name = ${log_group_name}

[/var/log/elasticsearch]
file = /var/log/elasticsearch/magento*.log
log_stream_name = /var/log/elasticsearch.log
log_group_name = ${log_group_name}

EOF
service awslogs start

# Swap
fallocate -l 8G /swap
chmod 600 /swap
mkswap /swap
swapon /swap

# ElasticSearch
yum remove -y java-1.7.0-openjdk
yum install -y java-1.8.0
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.4.rpm
yum localinstall -y elasticsearch-6.8.4.rpm
cd /usr/share/elasticsearch/bin
./elasticsearch-plugin install discovery-ec2 --batch

cd /etc/elasticsearch/
sed -i "s/-Xms1g/-Xms4g/g" jvm.options
sed -i "s/-Xmx1g/-Xmx4g/g" jvm.options

mkdir -p /data/elasticsearch
chown -R elasticsearch:elasticsearch /data/elasticsearch/

f_master="Name=tag:ClusterRole,Values=master"
f_running="Name=instance-state-name,Values=running"
f_brand="Name=tag:Brand,Values=${brand_short_name}"
f_mageenv="Name=tag:MagentoInfrastructureEnv,Values=${magento_infra_env}"
MASTER_NODE_IP=`aws ec2 describe-instances --region ${aws_region} --filters "$f_master" "$f_running" "$f_brand" "$f_mageenv" --output text --query "Reservations[].Instances[].PrivateIpAddress" | sed 's/\s/,/g'`
ZONES=`aws ec2 describe-availability-zones --region ${aws_region} --output text | awk -vORS=, '{print $5}' | sed 's/,$/\n/'`

cat > /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: magento-${brand_full_name}
#cluster.routing.allocation.awareness.attributes: zone
#cluster.routing.allocation.awareness.force.zone.values: $ZONES
node.master: true
node.data: true
node.ingest: true
discovery.zen.hosts_provider: ec2
discovery.zen.ping.unicast.hosts: [$MASTER_NODE_IP]
discovery.zen.minimum_master_nodes: 2
network.host: [_site_]
path.logs: /var/log/elasticsearch
path.data: /data/elasticsearch
EOF

echo "elasticsearch hard  nproc 4096" | sudo tee -a /etc/security/limits.conf
echo "elasticsearch soft  nproc 4096" | sudo tee -a /etc/security/limits.conf

service elasticsearch start

echo "Done"