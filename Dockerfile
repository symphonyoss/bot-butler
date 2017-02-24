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

# Install Yarn and configure bot working directory
    USER butler
    RUN curl -o- -L https://yarnpkg.com/install.sh | bash
    RUN $HOME/.yarn/bin/yarn install --pure-lockfile
    # Not sure why this is needed, not working to define as devDependencies in package.json
    RUN $HOME/.yarn/bin/yarn add yo generator-hubot --dev
    RUN $HOME/.yarn/bin/yarn run generate-hubot

# Lets get this show on the road:
    EXPOSE 8080
    ENTRYPOINT $HOME/.yarn/bin/yarn run start-bot-butler
