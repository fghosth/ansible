yum install python36u python36u-devel -y#!/bin/bash
yum install epel-release -y
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
yum install python36u python36u-devel -y
yum install -y cyrus-sasl-lib.x86_64 cyrus-sasl-devel.x86_64 libgsasl-devel.x86_64
ln -s /bin/python3.6 /bin/python3
yum install python36u-pip -y
ln -s /bin/pip3.6 /bin/pip3
pip3 install --upgrade pip
yum install gcc-c++ mariadb-devel -y
##mysql 修改
#explicit_defaults_for_timestamp=1
AIRFLOW_GPL_UNIDECODE=yes pip3 install apache-airflow
pip3 install apache-airflow[all]
pip3 install gevent
cat <<EOF > /etc/profile.d/airflow.sh
#!/bin/bash 
export AIRFLOW_HOME=/opt/airflow
EOF
source /etc/profile.d/airflow.sh
cd /opt && airflow
##修改配置文件
#dags_folder = /opt/airflow/src/dags
#sql_alchemy_conn = mysql://airflow:zaq1xsw2CDE#@rm-bp1221kxc3282rejc.mysql.rds.aliyuncs.com:3306/airflow
#executor = LocalExecutor
#load_examples = False
#default_timezone = utc
#worker_class = gevent
#authenticate = True
#dag_default_view = graph
#auth_backend = airflow.api.auth.backend.default
#rbac = True
#max_threads = 4

airflow initdb
#cp service file to /etc/systemd/system
scp airflow-webserver.service root@stg-af:/etc/systemd/system
scp airflow-scheduler.service root@stg-af:/etc/systemd/system
airflow create_user --username admin --firstname admin --lastname admin --email hua.fan@uuabc.com --role Admin --password zaqwedcxs
