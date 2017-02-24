FROM nodesource/node:latest
MAINTAINER "Vinay" <vinay@symphony.com>

# Required environment variables
    ENV container docker

# Create user account for bot
    RUN groupadd -g 501 butler && \
    useradd -m -u 501 -g 501 butler
    WORKDIR /home/butler

# Install project root folder
    ADD . /home/butler

# Add external directories (but can be overridden at docker run)
    # ADD ./bootstrap /home/butler/bootstrap
    # ADD ./env.sh /home/butler/env.sh
    # ADD ./certs /home/butler/certs/

# Update file permissions
    RUN chown -R butler:butler /home/butler

# Configure bot working directory
    USER butler
    # Not sure why this is needed, not working to define as devDependencies in package.json
    RUN npm install yo generator-hubot --save-dev
    RUN npm run generate-hubot

# Lets get this show on the road:
    ENTRYPOINT npm run start-bot-butler
