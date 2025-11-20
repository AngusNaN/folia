FROM eclipse-temurin:latest
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    mcrcon

RUN apt-get update && \
    apt-get install -y build-essential git && \
    git clone https://github.com/Tiiffi/mcrcon.git && \
    cd mcrcon && \
    make && \
    cp mcrcon /usr/local/bin/ && \
    cd .. && \
    rm -rf mcrcon && \
    apt-get purge -y build-essential git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

LABEL Author Endkind Ender <endkind.ender@endkind.net>

COPY getFolia.sh /endkind/getFolia.sh
COPY docker-entrypoint.sh /endkind/docker-entrypoint.sh

RUN chmod +x /endkind/getFolia.sh
RUN chmod +x /endkind/docker-entrypoint.sh

ARG FOLIA_VERSION=latest
RUN echo "$FOLIA_VERSION" > /endkind/folia_version

WORKDIR /folia

VOLUME /folia

ENV MIN_RAM=512M
ENV MAX_RAM=1G
ENV JAVA_FLAGS="--add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20"
ENV FOLIA_FLAGS="--nojline"

ENTRYPOINT ["/endkind/docker-entrypoint.sh"]
