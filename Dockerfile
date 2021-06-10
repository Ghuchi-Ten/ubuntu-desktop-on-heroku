# ------------------------------------------------------------
# Start with Ubuntu Groovy Gorilla
# ------------------------------------------------------------

FROM ubuntu:18.04

# ------------------------------------------------------------
# Set environment variables
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# Set the sources
# ------------------------------------------------------------
#RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\n' > /etc/apt/sources.list


# ------------------------------------------------------------
# Install and Configure
# ------------------------------------------------------------

RUN apt-get update && apt-get install -y --no-install-recommends \
    dbus-x11 nano sudo bash net-tools \
    novnc x11vnc xvfb \
    zip unzip expect supervisor curl git wget g++ ssh terminator htop gnupg2 locales \
    xfce4 ibus ibus-clutter ibus-gtk ibus-gtk3 \
    gnome-shell ubuntu-gnome-desktop gnome-session gdm3 tasksel \
    gnome-session gdm3 tasksel \
    
     firefox \
	    qbittorrent \
	    hexchat \
	    file-roller \
	    unzip \
	    unrar \
	    vlc \
	    apt-utils \
                 xz-utils \
	         lintian \
		 megatools \
		 vim \
         mkvtoolnix mkvtoolnix-gui \
         handbrake-cli \
         ffmpeg \
         gedit \

    chromium-browser 

RUN apt-get autoclean
RUN apt-get autoremove

RUN dpkg-reconfigure locales

# MEGA-SYNC
RUN wget --no-check-certificate https://mega.nz/linux/MEGAsync/xUbuntu_18.04/amd64/megasync_4.4.0-1.1_amd64.deb
RUN mv /megasync_4.4.0-1.1_amd64.deb /1.deb
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt install --yes /1.deb
RUN sudo apt --fix-broken install

#nautilus-megasync
RUN wget --no-check-certificate https://mega.nz/linux/MEGAsync/xUbuntu_18.04/amd64/nautilus-megasync_3.6.6_amd64.deb
RUN mv /nautilus-megasync_3.6.6_amd64.deb /2.deb
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt install --yes /2.deb
RUN sudo apt --fix-broken install


# ------------------------------------------------------------
# Add the Resources and Set Up the System
# ------------------------------------------------------------

COPY . /system

# @todo: Update the noVNC Web Page Resources to Support Legacy Browsers
# RUN unzip /system/resources/novnc.zip -d /system
# RUN rm -rf /usr/share/novnc
# RUN mv /system/novnc /usr/share/

RUN cp /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html
RUN sed "s|<title>noVNC</title>|<title>Ubuntu Desktop</title>|g" /usr/share/novnc/index.html > /usr/share/novnc/index-updated.html
RUN mv /usr/share/novnc/index-updated.html /usr/share/novnc/index.html
RUN cp /system/resources/favicon.ico /usr/share/novnc/favicon.ico

RUN chmod +x /system/conf.d/websockify.sh
RUN chmod +x /system/run.sh

RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
RUN echo "deb http://deb.anydesk.com/ all main"  >> /etc/apt/sources.list
RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub -P /app
RUN wget --no-check-certificate -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY -O /app/anydesk.key
RUN apt-key add /app/anydesk.key
RUN apt-key add /app/linux_signing_key.pub
RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        google-chrome-stable \
	anydesk

CMD ["/system/run.sh"]
