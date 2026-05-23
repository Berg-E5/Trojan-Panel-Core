FROM alpine:3.15
WORKDIR /tpdata/trojan-panel-core/
ENV TZ=Asia/Shanghai \
    GIN_MODE=release
RUN apk add --no-cache bash tzdata ca-certificates \
    && rm -rf /var/cache/apk/*
COPY build/trojan-panel-core /tpdata/trojan-panel-core/
COPY bin/xray/config/ /tpdata/trojan-panel-core/config/xray/ || true
COPY bin/trojango/config/ /tpdata/trojan-panel-core/config/trojango/ || true
COPY bin/naiveproxy/config/ /tpdata/trojan-panel-core/config/naiveproxy/ || true
COPY bin/hysteria/config/ /tpdata/trojan-panel-core/config/hysteria/ || true
COPY bin/hysteria2/config/ /tpdata/trojan-panel-core/config/hysteria2/ || true
ENTRYPOINT chmod 777 /tpdata/trojan-panel-core/trojan-panel-core \
    && /tpdata/trojan-panel-core/trojan-panel-core \
    -host=${mariadb_ip:-127.0.0.1} \
    -port=${mariadb_port:-9507} \
    -user=${mariadb_user:-root} \
    -password=${mariadb_pas:-123456} \
    -database=${database:-trojan_panel_db} \
    -accountTable=${account_table:-account} \
    -redisHost=${redis_host:-127.0.0.1} \
    -redisPort=${redis_port:-6378} \
    -redisPassword=${redis_pass:-123456} \
    -crtPath=${crt_path:-/tpdata/cert/trojan-panel-core.crt} \
    -keyPath=${key_path:-/tpdata/cert/trojan-panel-core.key} \
    -grpcPort=${grpc_port:-8100} \
    -serverPort=${server_port:-8082}

