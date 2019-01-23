#!/bin/bash
#mlist="CampaignID"
mlist="AffiliateNetworkID CampaignID FlowID LanderID OfferID TrafficSourceID"
elist="v1 v2 v3 v4 v5 v6 v7 v8 v9 v10"
allList="CampaignID OfferID FlowID LanderID AffiliateNetworkID TrafficSourceID Language Model Country City Region ISP MobileCarrier Domain DeviceType Brand OS OSVersion Browser BrowserVersion ConnectionType v1 v2 v3 v4 v5 v6 v7 v8 v9 v10"
 for i in $mlist;
        do
        {
		for j in $elist;
    	    do
        	{
			measurement=tracking_${i}_${j}
                	echo "=========删除${measurement}============="
			ansible influxdb -m shell -a "influx -username 'derek' -password 'zaqwedcxs' -database 'tracking' -execute \"drop measurement ${measurement}\" " -f 6
        	}
	    done
        }
done


