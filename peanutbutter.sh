#!/bin/bash

# Install Jellyfin
curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash

# Download and install Mali GPU driver
wget https://github.com/tsukumijima/libmali-rockchip/releases/download/v1.9-1-2131373/libmali-valhall-g610-g24p0-gbm_1.9-1_arm64.deb
sudo apt install -y ./libmali-valhall-g610-g24p0-gbm_1.9-1_arm64.deb

# Comment out panthor GPU overlay if present
sudo sed -i 's/^overlays=panthor-gpu/#overlays=panthor-gpu/' /boot/armbianEnv.txt

# Add udev rules
cat <<EOF | sudo tee /etc/udev/rules.d/99-rk-device-permissions.rules
KERNEL=="mpp_service", MODE="0660", GROUP="video"
KERNEL=="rga", MODE="0660", GROUP="video"
KERNEL=="system", MODE="0666", GROUP="video"
KERNEL=="system-dma32", MODE="0666", GROUP="video"
KERNEL=="system-uncached", MODE="0666", GROUP="video"
KERNEL=="system-uncached-dma32", MODE="0666", GROUP="video" RUN+="/usr/bin/chmod a+rw /dev/dma_heap"
EOF

# Add Jellyfin to necessary groups
sudo usermod -aG render jellyfin
sudo usermod -aG video jellyfin

# Restart Jellyfin service
sudo systemctl restart jellyfin

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Reboot the system
sudo reboot now

