FROM arm64v8/debian:bullseye-slim

ARG ssid=WIFI_AP
ARG passphrase=helloworld
ARG interface=wlan0
ARG country=DE
ARG web_port=8088

RUN apt update && apt install -y sudo wget procps curl systemd && rm -rf /var/lib/apt/lists/*
RUN wget https://install.raspap.com -O installer.sh && bash installer.sh -y
RUN sed -i.bak "s/80/${web_port}/" /etc/lighttpd/lighttpd.conf

RUN sed -i.bak "s/GB/${country}/" /etc/hostapd/hostapd.conf
RUN sed -i.bak "s/ChangeMe/${passphrase}/" /etc/hostapd/hostapd.conf
RUN sed -i.bak "s/wlan0/${interface}/" /etc/hostapd/hostapd.conf
RUN sed -i.bak "s/raspi-webgui/${ssid}/" /etc/hostapd/hostapd.conf


CMD /usr/sbin/hostapd -B /etc/hostapd/hostapd.conf && \
    service lighttpd restart && \
    tail -f /var/log/lighttpd/error.log
