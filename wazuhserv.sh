 #!/bin/bash

rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
cat > /etc/yum.repos.d/wazuh.repo <<\EOF
[wazuh_repo]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=Wazuh repository
baseurl=https://packages.wazuh.com/3.x/yum/
protect=1
EOF

yum install wazuh-manager -y
systemctl status wazuh-manager
systemctl start wazuh-manager
service wazuh-manager status



curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y
node --version
npm --version




yum install wazuh-api -y
systemctl status wazuh-api


sed -i "s/^enabled=1/enabled=0/" /etc/yum.repos.d/wazuh.repo




rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
cat > /etc/yum.repos.d/elastic.repo << EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF


yum install filebeat-7.1.1 -y
curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/v3.9.2/extensions/filebeat/7.x/filebeat.yml
chmod go+r /etc/filebeat/filebeat.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v3.9.2/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json

systemctl daemon-reload
systemctl enable filebeat.service
systemctl start filebeat.service


yum install elasticsearch-7.1.1 -y

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

yum install kibana-7.1.1 -y
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.9.2_7.1.1.zip

systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service

sed -i "s/^enabled=1/enabled=0/" /etc/yum.repos.d/elastic.repo
