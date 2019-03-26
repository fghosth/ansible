#!/bin/sh
###############################
#功能：centos7.X 安全，优化配置
#作者：derek
#时间：2016.8.23
###############################
    #1.删除系统特殊的的用户帐号 通常是:adm lp sync shutdown halt mail news uucp operator games gopher ftp
    #2.删除系统特殊的组帐号 通常是:adm lp mail news uucp games dip pppusers popusers slipusers
    #3.设置密码最小长度为8位
    #4.设置登录自动注销时间 300秒 5分钟
    #5.限制Shell命令记录大小
    #6.注销时删除命令记录
    #7.阻止任何人su作为root 除了特定的组
    #8.禁止root远程登录
    #9.修改ssh服务的sshd 端口
    #10.关闭不需要的服务 acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans microcode_ctl netfs nfs nfslock nscd pcscd portmap readahead_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd
    #11.阻止系统响应任何从外部/内部来的ping请求
    #12.修改“//tc/host.conf”文件第一项设置首先通过DNS解析IP地址，然后通过hosts文件解析。第二项设置检测是否“/etc/hosts”文件>>  >    中的主机是否拥有多个IP地址（比如有多个以太口网卡）。第三项设置说明要注意对本机未经许可的电子欺骗
    #13.禁止Control-Alt-Delete键盘关闭命令 TODO 未验证
    #14.用chattr命令给下面的文件加上不可更改属性 保护系统重要文件
    #15.系统文件权限修改
    #16.时区调整,时间同步  $1 时区文件
    #17.英文版支持中文
    #18.限制ssh登录ip  $1 以空格分割的ip字符串 允许的ip
    #19.禁止selinux
    #20.优化ssh 禁用GSSAPI来认证，也禁用DNS反向解析，加快SSH登陆速度
    #21.关闭ipv6 TODO 未验证，使用前验证
    #22.linux 内核优化

LOGFILE="setCentos.log"
ERRORFILE="setCentosError.log"
rm -rf $LOGFILE
exec 2>$ERRORFILE
#输出到屏幕,文件                                                                                                           
logMsg(){
#40;37m 黑底白字  
#41;37m 红底白字 
#42;37m 绿底白字  
#43;37m 黄底白字  
#44;37m 蓝底白字  
#45;37m 紫底白字  
#46;37m 天蓝底白字 
#47;30m 白底黑字 
   if [ "$3" != "" ]; then
        case "$3" in
            'red')
            echo -e "\033[31m $1 \033[0m";; 
            'yellow')
            echo -e "\033[33m $1 \033[0m";; 
            'blue')
            echo -e "\033[34m $1 \033[0m";; 
            'white')
            echo -e "\033[37m $1 \033[0m";; 
            *)
            echo "$1";; 
        esac 
   else
       echo $1
   fi
   echo $1>> $2
} 
#合并错误日志到主日志中
mergeLog(){
    logMsg "++++++++++++以下为错误日志++++++++++" "$LOGFILE" "white" 
    cat $ERRORFILE >> $LOGFILE
    logMsg "++++++++++++错误日志结束++++++++++" "$LOGFILE" "white" 
    rm -rf $ERRORFILE
    exec 2>$ERRORFILE  #在删除错误日志后需要再次捕捉错误日志:w
}
#1.删除系统特殊的的用户帐号 通常是:adm lp sync shutdown halt mail news uucp operator games gopher ftp
delUser(){
    local userList="adm lp sync shutdown halt mail news uucp operator games gopher ftp"
    logMsg "==========1.删除系统特殊的的用户帐号===========" "$LOGFILE" "yellow" 
    for i in $userList ;do 
       logMsg "删除帐号$i" "$LOGFILE" 
       userdel $i >> $LOGFILE
    done
    mergeLog
}
#2.删除系统特殊的组帐号 通常是:adm lp mail news uucp games dip pppusers popusers slipusers
delGroup(){
    local groupList="adm lp mail news uucp games dip pppusers popusers slipusers"
    logMsg "==========2.删除系统特殊的组帐号===========" "$LOGFILE" "yellow" 
    for i in $groupList ;do 
       logMsg "删除组$i" "$LOGFILE" 
       groupdel $i >> $LOGFILE
    done
    mergeLog
}
#3.设置密码最小长度为8位
setMinPasswd(){
    logMsg "==========3.设置密码最小长度为8位===========" "$LOGFILE" "yellow" 
    local conf="/etc/login.defs"
    local keyw="^PASS_MIN_LEN"
    local line_num=`cat $conf | awk "/$keyw/{print NR}"`
    #TODO 目前按照默认5位替换，如果小于5就不能达到预期效果以后更改
    sed -i "${line_num}s/5/8/g" $conf
    mergeLog
}

#4.设置登录自动注销时间
setLogoutTimeout(){
    logMsg "==========4.设置登录自动注销时间===========" "$LOGFILE" "yellow" 
    local conf="/etc/profile"
    local keyw="^HISTSIZE"
    local line_num=`cat $conf | awk "/$keyw/{print NR}"`
    local aline="TMOUT=$1"  #300秒 5分钟
    sed -i "${line_num}a $aline" $conf
    source $conf
    mergeLog
}

#5.限制Shell命令记录大小
setHistoryLimit(){
    logMsg "==========5.限制Shell命令记录大小===========" "$LOGFILE" "yellow" 
#TODO 完成功能
    mergeLog
}

#6.注销时删除命令记录
delHistory(){
    logMsg "==========6.注销时删除命令记录==========" "$LOGFILE" "yellow" 
#TODO 完成功能
    mergeLog

}

#7.阻止任何人su作为root 除了特定的组
#auth sufficient /lib/security/$ISA/pam_rootok.so debug
#auth required /lib/security/$ISA/pam_wheel.so group=website
denySu(){
    logMsg "=========7.阻止任何人su作为root 除了特定的组===========" "$LOGFILE" "yellow"
#TODO 完成功能
    mergeLog
}

#8.禁止root远程登录
denyRootSsh(){
    logMsg "=========8.禁止root远程登录===========" "$LOGFILE" "yellow" 
    conf="/etc/ssh/sshd_config"
    keyw="^PermitRootLogin"
    keywc="^#PermitRootLogin"
    local line_num=`cat $conf | awk "/$keyw/{print NR}"`
    if [[ "$line_num" =~ [1-9]+ ]]; then
        #echo "sed -i \"${line_num}d\" $conf" 
        sed -i "${line_num}s/yes/no/g" $conf
    else
        local line_numc=`cat $conf | awk "/$keywc/{print NR}"`
        sed -i "${line_numc}s/yes/no/g" $conf
        sed -i "${line_numc}s/$keywc/PermitRootLogin/g" $conf
    fi
    service sshd restart
    mergeLog
}

#9.修改ssh服务的sshd 端口
setSshPort(){
    logMsg "=========9.修改ssh服务的sshd 端口===========" "$LOGFILE" "yellow"
    conf="/etc/ssh/sshd_config"
    keyw="^Port"
    port=$1
    portStr="Port $port"
    local line_num=`cat $conf | awk "/$keyw/{print NR}"`
    if [[ "$line_num" =~ [1-9]+ ]]; then
        #echo "sed -i \"${line_num}d\" $conf" 
        sed -i "${line_num}d" $conf
    fi
    echo $portStr >> $conf
    service sshd restart
systemctl start firewalld
firewall-cmd --permanent --add-port=$port/tcp
firewall-cmd --add-port=$port/tcp
    #iptables -A INPUT -p tcp --dport $port -j ACCEPT
    #iptables -A OUTPUT -p udp --sport $port -j ACCEPT
    #service iptables restart
    local checked=`netstat -lnp|grep ssh  | awk  -F ' ' '{print $4}' | head -n 1 | awk  -F ':' '{print $2}'`
    if [ "$checked" != "$port" ]; then                  
        #echo "sed -i \"${line_num}d\" $conf"             
        logMsg "-------------ssh服务启动失败------------" "$LOGFILE" "red"
    fi
    mergeLog
}


#10.关闭不需要的服务 acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans microcode_ctl netfs nfs nfslock nscd pcscd portmap readahead_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd
#chkconfig --level 345 apmd off ##笔记本需要
#chkconfig --level 345 netfs off ## nfs客户端
#chkconfig --level 345 yppasswdd off ## NIS服务器，此服务漏洞很多
#chkconfig --level 345 ypserv off ## NIS服务器，此服务漏洞很多
#chkconfig --level 345 dhcpd off ## dhcp服务
#chkconfig --level 345 portmap off ##运行rpc(111端口)服务必需
#chkconfig --level 345 lpd off ##打印服务
#chkconfig --level 345 nfs off ## NFS服务器，漏洞极多
#chkconfig --level 345 sendmail off ##邮件服务, 漏洞极多
#chkconfig --level 345 snmpd off ## SNMP，远程用户能从中获得许多系统信息
#chkconfig --level 345 rstatd off ##避免运行r服务，远程用户可以从中获取很多信息
#chkconfig --level 345 atd off ##和cron很相似的定时运行程序的服务
#注：以上chkcofig 命令中的3和5是系统启动的类型，以下为数字代表意思
#0:开机(请不要切换到此等级)
#1:单人使用者模式的文字界面
#2:多人使用者模式的文字界面,不具有网络档案系统(NFS)功能
#3:多人使用者模式的文字界面,具有网络档案系统(NFS)功能
#4:某些发行版的linux使用此等级进入x windows system
#5:某些发行版的linux使用此等级进入x windows system
#6:重新启动
#如果不指定--level 单用on和off开关，系统默认只对运行级3，4，5有效
#chkconfig cups off #打印机
#chkconfig bluetooth off # 蓝牙
#chkconfig hidd off # 蓝牙
#chkconfig ip6tables off # ipv6
#chkconfig ipsec off # vpn
#chkconfig auditd off #用户空间监控程序
#chkconfig autofs off #光盘软盘硬盘等自动加载服务
#chkconfig avahi-daemon off #主要用于Zero Configuration Networking ，一般没什么用建议关闭
#chkconfig avahi-dnsconfd off #主要用于Zero Configuration Networking ,同上,建议关闭
#chkconfig cpuspeed off #动态调整CPU频率的进程，在服务器系统中这个进程建议关闭
#chkconfig isdn off #isdn
#chkconfig kudzu off #硬件自动监测服务
#chkconfig nfslock off #NFS文档锁定功能。文档共享支持，无需的能够关了
#chkconfig nscd off #负责密码和组的查询，在有NIS服务时需要
#chkconfig pcscd off #智能卡支持，,如果没有可以关了
#chkconfig yum-updatesd off #yum更新
#chkconfig acpid off
#chkconfig autofs off
#chkconfig firstboot off
#chkconfig mcstrans off #selinux
#chkconfig microcode_ctl off
#chkconfig rpcgssd off
#chkconfig rpcidmapd off
#chkconfig setroubleshoot off
#chkconfig xfs off
#chkconfig xinetd off
#chkconfig gpm off #鼠标
#chkconfig restorecond off #selinux
#chkconfig haldaemon off
#chkconfig sysstat off
#chkconfig readahead_early off
#chkconfig anacron off
#需要保留的服务
#crond , irqbalance , microcode_ctl ,network , sshd ,syslog
closeUnService(){
    logMsg "=========10.关闭不需要的服务===========" "$LOGFILE" "yellow"
    local serviceName="acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans microcode_ctl netfs nfs nfslock nscd pcscd portmap readahea d_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd"
    #停止服务
   for i in $serviceName ;do 
       #echo $i
       service $i stop
   done 
   #卸载服务
   for i in $serviceName ;do 
       chkconfig $i off
   done 
   
    mergeLog
}


#11.阻止系统响应任何从外部/内部来的ping请求
blockPing(){
    logMsg "=========11.阻止系统响应任何从外部/内部来的ping请求==========" "$LOGFILE" "yellow"
    echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
    mergeLog
}

#12.修改“/etc/host.conf”文件第一项设置首先通过DNS解析IP地址，然后通过hosts文件解析。第二项设置检测是否“/etc/hosts”文件中的主机是否拥有多个IP地址（比如有多个以太口网卡）。第三项设置说明要注意对本机未经许可的电子欺骗
modifyHostConf(){
    logMsg "=========12.修改“/etc/host.conf”文件==========" "$LOGFILE" "yellow"
    #TODO 判断是否已经有这几个属性，没有才添加
    echo "order hosts,bind" >> /etc/host.conf
    echo "multi on" >> /etc/host.conf
    echo "nospoof on" >> /etc/host.conf
    mergeLog

}

#13.禁止Control-Alt-Delete键盘关闭命令
disableCAD(){
    logMsg "=========13.禁止Control-Alt-Delete键盘关闭命令==========" "$LOGFILE" "yellow"
    local conf='/etc/inittab'
    local str='^ca::ctrlaltdel:\/sbin\/shutdown'
    local line_num=`cat $conf | awk "/$str/{print NR}"`
    echo $line_num
    if [[ "$line_num" =~ [1-9]+ ]]; then
        sed -i "${line_num}s/^/#/g" $conf
    fi
    mergeLog
}

#14.用chattr命令给下面的文件加上不可更改属性 保护系统重要文件
protectImp(){
    logMsg "=========14.用chattr命令给下面的文件加上不可更改属性 保护系统重要文件==========" "$LOGFILE" "yellow"
    local file='/etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/services /etc/grub.conf'
    for i in $file ;do 
        chattr +i $i
    done
    mergeLog
}


#15.系统文件权限修改
modifySystemFile(){
    logMsg "=========15.系统文件权限修改==========" "$LOGFILE" "yellow"
    #修改init目录文件执行权限
    chmod -R 700 /etc/init.d/*
    #修改系统引导文件
    chmod 600 /etc/grub.conf
    #修改部分系统文件的SUID和SGID的权限
    local sysfile="/usr/bin/chage /usr/bin/gpasswd /usr/bin/wall /usr/bin/chfn /usr/bin/chsh /usr/bin/newgrp /usr/bin/write /usr/sbin/usernetctl /usr/sbin/traceroute /bin/mount /bin/umount /sbin/netreport"
    for i in $sysfile ;do
        chmod a-s $i
    done
    mergeLog
}

#16.时区调整,时间同步  $1 时区文件
timeZone(){
    logMsg "=========16.时区调整,时间同步==========" "$LOGFILE" "yellow"
    local timepath='/usr/share/zoneinfo'
    local localtime='/etc/localtime'
    rm -rf $localtime 
    ln -s $timepath/$1 $localtime 
    
    #时间同步
    yum -y install ntp
    chkconfig --levels 235 ntpd on
    ntpdate ntp.api.bz
    service ntpd start
    mergeLog
}

#17.英文版支持中文
supportCN(){
    logMsg "=========17.英文版支持中文==========" "$LOGFILE" "yellow"
    #TODO 判断是否存在
   echo "LANG=\"en_US.UTF-8\"" >> /etc/sysconfig/i18n 
   echo "SUPPORTED=\"zh_CN.UTF-8:zh_CN:zh\"" >> /etc/sysconfig/i18n 
   echo "SYSFONT=\"latarcyrheb-sun16"\" >> /etc/sysconfig/i18n 
    mergeLog
}

#18.限制ssh登录ip  $1 以空格分割的ip字符串 允许的ip
sshIPLimit(){
    logMsg "=========18.限制ssh登录ip==========" "$LOGFILE" "yellow"
    echo "sshd:ALL" >> /etc/hosts.deny
    for i in $1 ;do
        echo sshd:$i >> /etc/hosts.allow
    done 
    mergeLog
}
#19.禁止selinux 
disableSelinux(){
    logMsg "=========19.禁止selinux==========" "$LOGFILE" "yellow"
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
    mergeLog
}
#20.优化ssh 禁用GSSAPI来认证，也禁用DNS反向解析，加快SSH登陆速度
optimizeSSH(){
    logMsg "=========20.优化ssh 禁用GSSAPI来认证，也禁用DNS反向解析，加快SSH登陆速度==========" "$LOGFILE" "yellow"
    sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
    service sshd restart
    mergeLog
}
#21.关闭ipv6 TODO 未验证，使用前验证 
disableIPV6(){
    logMsg "========21.关闭ipv6===========" "$LOGFILE" "yellow"
    cat > /etc/modprobe.conf << EOFI
alias net-pf-10 off
options ipv6 disable=1
EOFI
    echo "NETWORKING_IPV6=off" >> /etc/sysconfig/network
    service ip6tables stop
    service network restart
    chkconfig --level 235 ip6tables off
    mergeLog
}

#22.linux 内核优化
tuneKernel(){
    logMsg "========22.linux 内核优化===========" "$LOGFILE" "yellow"
    cat >> /etc/sysctl.conf << EOF
#1是开启SYN Cookies，当出现SYN等待队列溢出时，启用Cookies来处理，可防范少量SYN攻击，默认是0关闭 
net.ipv4.tcp_syncookies = 1
#1是开启重用，允许讲TIME_AIT sockets重新用于新的TCP连接，默认是0关闭 
net.ipv4.tcp_tw_reuse = 1
#TCP失败重传次数，默认是15，减少次数可释放内核资源 
net.ipv4.tcp_tw_recycle = 1
#应用程序可使用的端口范围 
net.ipv4.ip_local_port_range = 4096 65000
#系统同时保持TIME_WAIT套接字的最大数量，如果超出这个数字，TIME_WATI套接字将立刻被清除并打印警告信息，默认180000 
net.ipv4.tcp_max_tw_buckets = 5000
#进入SYN宝的最大请求队列，默认是1024 
net.ipv4.tcp_max_syn_backlog = 4096
#允许送到队列的数据包最大设备队列，默认300 
net.core.netdev_max_backlog =  10240
#listen挂起请求的最大数量，默认128 
net.core.somaxconn = 2048
#发送缓存区大小的缺省值 
net.core.wmem_default = 8388608
#接受套接字缓冲区大小的缺省值（以字节为单位） 
net.core.rmem_default = 8388608
#最大接收缓冲区大小的最大值 
net.core.rmem_max = 16777216
#发送缓冲区大小的最大值 
net.core.wmem_max = 16777216
#SYN-ACK握手状态重试次数，默认5 
net.ipv4.tcp_synack_retries = 2
#向外SYN握手重试次数，默认4 
net.ipv4.tcp_syn_retries = 2
#开启TCP连接中TIME_WAIT sockets的快速回收，默认是0关闭 
net.ipv4.tcp_tw_recycle = 1
#系统中最多有多少个TCP套接字不被关联到任何一个用户文件句柄上，如果超出这个数字，孤儿连接将立即复位并打印警告信息 
net.ipv4.tcp_max_orphans = 3276800
#net.ipv4.tcp_mem[0]:低于此值，TCP没有内存压力； 
#net.ipv4.tcp_mem[1]:在此值下，进入内存压力阶段； 
#net.ipv4.tcp_mem[2]:高于此值，TCP拒绝分配socket。内存单位是页，可根据物理内存大小进行调整，如果内存足够大的话，可适当往上调。上述内存单位是页，而不是字节。
net.ipv4.tcp_mem = 94500000 915000000 927000000 
EOF
/sbin/sysctl -p
    mergeLog
}

#23.添加防火墙规则，只添加了ssh 其他规则根据情况添加
setIptables(){
    logMsg "========#23.添加防火墙规则，只添加了ssh 其他规则根据情况添加===========" "$LOGFILE" "yellow"
    local sshport=$1
    service iptables start
    iptables -F
    iptables -X
    iptables -Z
    iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED,NEW --dport $sshport -j ACCEPT
    iptables -P INPUT DROP
    iptables -P OUTPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables-save
    mergeLog
}
#24添加firewalld规则
function setFirewalld(){
 logMsg "========#24.添加防火墙规则,开放常规端口===========" "$LOGFILE" "yellow"
 local tcpport="12201 2377 7946 22 3306 80 8888 21 443 8080 25 110 5000 9200 9300 2222 65532 6379 3000 4232 6000-8000 9000-10000 8300 8301 8302 8400 8500 8600 11211"
 for i in $tcpport
   do
   firewall-cmd --permanent --add-port=$i/tcp
   firewall-cmd --add-port=$i/tcp
   done
 local udpport="12201 1514 7946 4789 53 8301 8302 5353"
 for i in $udpport
   do
   firewall-cmd --permanent --add-port=$i/udp
   firewall-cmd --add-port=$i/udp
   done
mergeLog
}
main(){
    #1.删除系统特殊的的用户帐号 通常是:adm lp sync shutdown halt mail news uucp operator games gopher ftp
    delUser
    #2.删除系统特殊的组帐号 通常是:adm lp mail news uucp games dip pppusers popusers slipusers
    delGroup
    #3.设置密码最小长度为8位
    setMinPasswd
    #4.设置登录自动注销时间 300秒 5分钟
    setLogoutTimeout '300'
    #5.限制Shell命令记录大小
    setHistoryLimit
    #6.注销时删除命令记录
    delHistory
    #7.阻止任何人su作为root 除了特定的组
    #denySu
    #8.禁止root远程登录
    denyRootSsh
    #9.修改ssh服务的sshd 端口
    setSshPort '33699'
    #10.关闭不需要的服务 acpid anacron apmd atd auditd autofs avahi-daemon avahi-dnsconfd bluetooth cpuspeed cups dhcpd firstboot gpm haldaemon hidd ip6tables ipsec isdn kudzu lpd mcstrans microcode_ctl netfs nfs nfslock nscd pcscd portmap readahead_early restorecond rpcgssd rpcidmapd rstatd sendmail setroubleshoot snmpd sysstat xfs xinetd yppasswdd ypserv yum-updatesd
    closeUnService
    #11.阻止系统响应任何从外部/内部来的ping请求
    blockPing
    #12.修改“//tc/host.conf”文件第一项设置首先通过DNS解析IP地址，然后通过hosts文件解析。第二项设置检测是否“/etc/hosts”文件>>  >    中的主机是否拥有多个IP地址（比如有多个以太口网卡）。第三项设置说明要注意对本机未经许可的电子欺骗
    modifyHostConf
    #13.禁止Control-Alt-Delete键盘关闭命令 TODO 未验证
    disableCAD
    #14.用chattr命令给下面的文件加上不可更改属性 保护系统重要文件
    protectImp
    #15.系统文件权限修改
    modifySystemFile
    #16.时区调整,时间同步  $1 时区文件
    timeZone 'Asia/Shanghai'
    #17.英文版支持中文
    #supportCN
    #18.限制ssh登录ip  $1 以空格分割的ip字符串 允许的ip
    #sshIPLimit  "192.168.20. 192.168.1."
    #19.禁止selinux
    #disableSelinux
    #20.优化ssh 禁用GSSAPI来认证，也禁用DNS反向解析，加快SSH登陆速度
    optimizeSSH
    #21.关闭ipv6 TODO 未验证，使用前验证
    #disableIPV6
    #22.linux 内核优化
    #tuneKernel
    #23.添加防火墙规则，只添加了ssh 其他规则根据情况添加 $1:ssh的端口号
    #setIptables 33688
    #24.设置firewalld
    setFirewalld
}
    setFirewalld
#main
    #setIptables 33688
