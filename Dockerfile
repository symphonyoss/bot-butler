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
    RUN rm -rf /var/lib/apt/lists/*

# Add external directories:
    ADD ./env.sh /home/butler/env.sh
    ADD ./certs /home/butler/certs/
    ADD ./src/scripts /home/butler/scripts/

# Update file permissions:
    RUN chown -R butler:butler /home/butler

# Create Butler bot instance:
    USER butler
    WORKDIR /home/butler
# RUN mkdir -p /home/butler/.config/configstore && \
#     echo "optOut: true" > /home/butler/.config/configstore/insight-yo.yml
    RUN npm run generate-hubot

# Lets get this show on the road:
    EXPOSE 8080
    ENTRYPOINT npm run start-bot-butler
