FROM openwrtorg/sdk

LABEL "com.github.actions.name"="OpenWrt SDK"

ADD entrypoint.sh /

USER root

ENTRYPOINT ["/entrypoint.sh"]
