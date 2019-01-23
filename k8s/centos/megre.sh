#!/bin/bash
#split -b 99m k8s1.13.2img.tar.gz k8s1.13.2_
cat k8s1.13.2_* > k8s1.13.2img.tar.gz
