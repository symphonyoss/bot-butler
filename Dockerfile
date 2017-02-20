FROM nodesource/node:latest
MAINTAINER "Vinay" <vinay@symphony.com>

# Required environment variables:
    ENV container docker

# Create user account for bot
    RUN groupadd -g 501 butler && \
    useradd -m -u 501 -g 501 butler

# Install required applications
    ADD ./package.json /home/butler/package.json
    WORKDIR /home/butler
    RUN npm install
    RUN npm install -g yo generator-hubot && \
    rm -rf /var/lib/apt/lists/*

# Add external directories:
    ADD ./config/certs /home/butler/certs/
    ADD ./config/scripts /home/butler/scripts/
    ADD ./start.sh /home/butler/

# Update file permissions:
    RUN chown -R butler:butler /home/butler && \
    chmod +x /home/butler/start.sh

# Create Butler bot instance:
    USER butler
    WORKDIR /home/butler
    RUN mkdir -p /home/butler/.config/configstore && \
    echo "optOut: true" > /home/butler/.config/configstore/insight-yo.yml
    RUN yo hubot --owner="Vinay <vinay@symphony.com>" --name="butler" --adapter="symphony" --defaults --no-insight

# Lets get this show on the road:
    EXPOSE 8080
    ENTRYPOINT ./start.sh
