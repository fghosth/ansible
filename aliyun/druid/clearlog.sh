#!/bin/bash
ansible aldruid -m shell -a "rm -rf /data/imply-2.6.3/var/sv/*.log"
