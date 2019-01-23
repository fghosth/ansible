#!/bin/bash
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel unixODBC-devel
tar zxvf otp_src_20.3.tar.tar
cd otp_src_20.3
./configure --prefix=/usr/local/erlang --with-ssl -enable-threads -enable-smmp-support -enable-kernel-poll --enable-hipe --without-javacmakmak
make && make install
echo "ERLANG_HOME=/usr/local/erlang" >> /etc/profile
echo 'PATH=$PATH:$JAVA_HOME/bin:$ERLANG_HOME/bin' >> /etc/profile
source /etc/profile
cd ..
xz -d rabbitmq-server-generic-unix-3.7.10.tar.xz
tar -xvf rabbitmq-server-generic-unix-3.7.10.tar
ln -s /data/rabbitmq_server-3.7.10/sbin/rarabbitmqctl /usr/local/bin/rabbitmqctl
ln -s /data/rabbitmq_server-3.7.10/sbin/rabbitmq-server /usr/local/bin/rabbitmq-server
ln -s /data/rabbitmq_server-3.7.10/sbin/rabbitmq-plugins /usr/local/bin/rabbitmq-plugins
ln -s /data/rabbitmq_server-3.7.10/sbin/rabbitmq-env /usr/local/bin/rabbitmq-env
cp /data/rabbitmq_delayed_message_exchange-20171201-3.7.x.ez /data/rabbitmq_server-3.7.10/plugins/


rabbitmq-server -detached
rabbitmq-plugins enable rabbitmq_management
/data/rabbitmq_server-3.7.10/sbin/rabbitmqctl add_user admin zaqwedcxs
/data/rabbitmq_server-3.7.10/sbin/rabbitmqctl set_permissions -p "/" admin '.*' '.*' '.*'
/data/rabbitmq_server-3.7.10/sbin/rabbitmqctl set_user_tags admin administrator

rabbitmq-plugins enable rabbitmq_delayed_message_exchange
rabbitmq-plugins list
