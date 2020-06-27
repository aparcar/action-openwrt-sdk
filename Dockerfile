FROM openwrtorg/sdk

LABEL "com.github.actions.name"="OpenWrt SDK"

LABEL version="0.0.1"

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
