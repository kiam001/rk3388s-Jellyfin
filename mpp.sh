#!/bin/bash
sudo sh -c "echo 1000 > /proc/mpp_service/load_interval" && sudo watch -n 1 cat /proc/mpp_service/load
