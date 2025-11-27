
FROM eclipse-temurin:latest


RUN apt-get update && \
    apt-get install -y curl jq tzdata git build-essential && \
    \

    git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon-build && \
    cd /tmp/mcrcon-build && \
    make && \
    cp mcrcon /usr/bin/mcrcon && \
    \

    cd / && \
    rm -rf /tmp/mcrcon-build && \
    apt-get purge -y git build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


ENV TZ=Europe/Berlin
ENV JAVA_OPTS="-Duser.timezone=Europe/Berlin"

LABEL Author Endkind Ender <endkind.ender@endkind.net>

COPY getFolia.sh /endkind/getFolia.sh
COPY docker-entrypoint.sh /endkind/docker-entrypoint.sh

RUN chmod +x /endkind/getFolia.sh
RUN chmod +x /endkind/docker-entrypoint.sh

ARG FOLIA_VERSION=latest
RUN echo "$FOLIA_VERSION" > /endkind/folia_version

WORKDIR /folia
VOLUME /folia

ENV MIN_RAM=12G
ENV MAX_RAM=24G

ENV JAVA_FLAGS="--add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15"

ENV FOLIA_FLAGS="--nojline"

ENTRYPOINT ["/endkind/docker-entrypoint.sh"]
