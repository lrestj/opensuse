#!/bin/bash

##### Tumbleweed Hyprland install #####

Apps="autofs avahi baobab kf6-breeze-icons breeze6-cursors brightnessctl btop cmake cups eog evince fastfetch fd figlet firewall-config firewall-applet fish file-roller font-manager fontawesome-fonts foot geany gnome-calculator git gnome-disk-utility go google-noto-coloremoji-fonts google-noto-fonts gthumb gvfs-backends gvim hplip hyprland hypridle hyprlock hyprshot hyprland-qt-support hyprland-qtutils hyprwayland-scanner intel-media-driver jetbrains-mono-fonts jq Mesa-libGL1 libtool libXt-devel libnotify-devel libreoffice-gtk3 lxqt-policykit mako NetworkManager-applet nfs-client nwg-look opi pamixer pavucontrol pinta power-profiles-daemon pipewire pipewire-jack libnotify-tools libqt5-qtwayland qt6ct rofi rsvg-thumbnailer simple-scan slurp swaybg symbols-only-nerd-fonts thunar thunar-archive-plugin gvfs-fuse gvfs-backend-samba tmux udiskie libva-utils waybar wireplumber wl-clipboard wireplumber wlogout wlsunset wofi xdg-desktop-portal-hyprland xdg-user-dirs xournalpp xwayland yazi"


tput setaf 166 bold; echo "✅ Instalace balíčků..."
sudo zypper al texlive &&
sudo zypper install $Apps &&
sudo opi -n brave &&	
tput setaf 166 bold; echo "✅ Instalace balíčků kompletní"
tput setaf 166 bold; echo "✅ Osobní nastavení... (ctrl-C = STOP)"
sleep 6
tput setaf 166 bold; echo "✅ Kopíruji konfiguraci z repozitáře"
echo ".cfg.git" >> .gitignore
git clone --bare https://github.com/lrestj/opensuse.git /home/libor/.cfg.git
# git clone --bare https://gitlab.com/lrestj/debian.git &&

git --git-dir=$HOME/.cfg.git/ --work-tree=$HOME checkout -f
tput setaf 166 bold; echo "✅ Konfigurace z repozitáře kompletní"
tput setaf 166 bold; echo "✅ Nastavení swap..."
echo vm.swappiness=10 | sudo tee /etc/sysctl.d/99-swappiness.conf
echo -e "\n"
tput setaf 166 bold; echo "✅ Nfs a aktivace služeb..."
echo -e "\n"

# NFS, services, configs:
sudo mkdir -p /data/nfs/ /data/nfs/ /data/nfs/ &&
sudo chmod -R ugo+rwx /data/nfs

sudo cp -rf /home/libor/.dotfiles/other/to-etc/auto.master /etc/
sudo cp -rf /home/libor/.dotfiles/other/to-etc/auto.nfs /etc/
sudo cp -rf /home/libor/.dotfiles/other/to-etc/systemd/sleep.conf.d /etc/systemd/
sudo cp -rf /home/libor/.dotfiles/other/to-etc/grub.d/40_custom /etc/grub.d/
gsettings set org.cinnamon.desktop.default-applications.terminal exec footclient
sudo cp /home/libor/.dotfiles/fonts/cybermedium.flf /usr/share/figlet/

git --git-dir=/home/libor/.cfg.git/ --work-tree=/home/libor remote remove origin
git --git-dir=/home/libor/.cfg.git/ --work-tree=/home/libor remote add github git@github.com:lrestj/opensuse.git
git --git-dir=/home/libor/.cfg.git/ --work-tree=/home/libor remote add gitlab git@gitlab.com:lrestj/opensuse.git
git config --global user.email "rest@seznam.cz"
git config --global user.name "LrestJ"

sudo systemctl enable autofs.service
sudo systemctl enable cups.service
sudo systemctl enable avahi-daemon.service
sudo systemctl disable NetworkManager-wait-online.service
sudo usermod -aG wheel libor
sudo cp -r /home/libor/.dotfiles/other/to-etc/systemd/system/getty@tty1.service.d /etc/systemd/system/
mkdir Public Videa Stažené Temp Hudba Obrázky
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

bash /home/libor/.dotfiles/scripts/clipse.sh
echo -e "\n"
tput setaf 166 bold; echo "✅ INSTALACE KOMPLETNÍ" 

echo -e "\n"
tput setaf 166 bold; echo "✅ Restart do nového systému... (ctrl-C = STOP)"
sleep 9
sudo systemctl reboot

##### END OF FILE #####
