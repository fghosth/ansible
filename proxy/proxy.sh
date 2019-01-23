#!/bin/sh
brook client -l 127.0.0.1:1087 -i 127.0.0.1 -s 45.43.60.7:31415 -p zaqwedcxs --tcpTimeout 60 --tcpDeadline 0 --udpDeadline 60 --udpSessionTime 60 --http &
export http_proxy=http://127.0.0.1:1087
export https_proxy=http://127.0.0.1:1087
