#!/bin/bash

for i in `find $* | grep .png$`; do sips -s format jpeg -s formatOptions 70 -Z 1400 "${i}" --out "${i%png}jpg"; 
done
