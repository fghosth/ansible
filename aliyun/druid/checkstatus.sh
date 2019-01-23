#!/bin/bash
ansible aldruid -m shell -a "netstat -nplt"
