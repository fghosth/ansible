#!/bin/bash  
#-------------CopyRight-------------  
#   Name:docker必备镜像
#   Version Number:1.00  
#   Language:bash shell  
#   Date:2016-10-26  
#   Author: Derek Fan 
#   Email:fghosth@163.com
#------------Environment------------  
#   Terminal: column 80 line 24  
#   Linux 3.10.1 i686  
#   GNU Bash 3.00.15  
#-----------------------------------  

#---------1. 开关-------------------
set -x
set -e
set -u
set -o
#-----------2. 环境变量------------
#PATH=/home/abc/bin:$PATH
#export PATH

#-----------3.source文件------------
#source lib/some_lib.sh 

#---------------4.常量--------------  
readonly ECHO="echo -ne"
readonly ESC="\033["
#--------------5.变量--------------  
#color  
NULL=0
BLACK=30
RED=31
GREEN=32
ORANGE=33
BLUE=34
PURPLE=35
SBLUE=36
GREY=37

#back color  
BBLACK=40
BRED=41
BGREEN=42
BORANGE=43
BBLUE=44
BPURPLE=45
BSBLUE=46
BGREY=47

#----------6.函数----------------
function pullImages(){
 docker pull alpine
 docker pull consul
 docker pull gliderlabs/registrator
 docker pull swarm
}
function main(){
pullImages
}

main "$@"

