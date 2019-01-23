#!/bin/bash
			database="tracking"
                	echo "=========删除${database}============="
			ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs'  -execute \"drop database ${database}\" " -f 6


