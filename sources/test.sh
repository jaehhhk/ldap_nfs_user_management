#!/bin/bash

#echo "/home/lee        cluster2(rw,anongid=1500,async,no_subtree_check)" >> /etc/exports

sed -i '37i\ last ALL=(ALL) NOPASSWD:ALL' /etc/sudoers
