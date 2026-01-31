FROM openjdk:27-ea-jdk-slim-bookworm

ARG MINECRAFT_MOD_VERSION=5.0.8
ARG MINECRAFT_MOD_NAME=SkyFactory-5
ARG MINECRAFT_MOD_PACKAGE=https://mediafilez.forgecdn.net/files/6290/699/${MINECRAFT_MOD_NAME}_Server_${MINECRAFT_MOD_VERSION}.zip
ARG MINECRAFT_MEMORY=4096m
ARG USER_NAME=minecraft
ARG SKIP_DOWNLOAD=false
RUN apt update && apt upgrade -y && apt install -y zip wget unzip 
RUN addgroup --gid 1234 ${USER_NAME} 
RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "${USER_NAME} user" ${USER_NAME}

RUN if [ "${SKIP_DOWNLOAD}" = "true" ]; then \
			echo "SKIP_DOWNLOAD=true -> skipping remote download of ${MINECRAFT_MOD_NAME} package"; \
		else \
			mkdir -p /tmp/feed-the-beast && cd /tmp/feed-the-beast && \ 
			wget -c ${MINECRAFT_MOD_PACKAGE} -O ${MINECRAFT_MOD_NAME}_Server.zip && \
			unzip ${MINECRAFT_MOD_NAME}_Server.zip -d /tmp/feed-the-beast && \
			chmod -R 777 /tmp/feed-the-beast && \
			chown -R minecraft /tmp/feed-the-beast && \
			cd /tmp/feed-the-beast && bash -x Install.sh && \ 
			chmod -R 777 /tmp/feed-the-beast && \
			chown -R minecraft /tmp/feed-the-beast; \
		fi

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER ${USER_NAME}

VOLUME /data
WORKDIR /data

EXPOSE 25565

CMD ["/start.sh"]

ENV MOTD="A Minecraft (${MINECRAFT_MOD_NAME} ${MINECRAFT_MOD_VERSION}) Server Powered by Docker"
ENV LEVEL="world"
ENV JVM_OPTS="-Xms${MINECRAFT_MEMORY} -Xmx${MINECRAFT_MEMORY}"