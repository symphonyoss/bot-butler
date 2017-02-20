# docker-butler
This is a Docker container for running Symphony Hubot (aka. Butler). [Symphony](http://www.symphony.com).

## Clone Repository
To clone this repository please use the following:

    git clone https://github.com/mistryvinay/docker-butler.git

## Configure Container
To configure your container please refer to the below.

Below is the folder structure of the Docker container.
butler
├── config
│   ├── certs
│   │   ├── bot.user5-PrivateKey.pem
│   │   └── bot.user5-PublicCert.pem
│   └── scripts
│       └── stock.coffee
├── Dockerfile
├── package.json
├── README.md
└── start.sh

1. Bot Certificates: Ensure that you load your Bot user certificate and PrivateKey into the folder butler/config/certs.  Which ever name you choose for your certificates ensure that the /butler/start.sh also references this certificate name as well. Below are the lines that should be edited:
    export HUBOT_SYMPHONY_PUBLIC_KEY=/home/butler/certs/bot.user5-PublicCert.pem
    export HUBOT_SYMPHONY_PRIVATE_KEY=/home/butler/certs/bot.user5-PrivateKey.pem
    export HUBOT_SYMPHONY_PASSPHRASE=changeit

2. Start.sh: This defines the environment variables at startup including your Pod information.  

3. Scripts:  This is where you can include your Hubot scripts.  These will be included in the build of the image.  You can also include an external scripts folder which will be loaded at runtime.  This is shown in the ## Run Container section.

4. Bot name:  Edit the /butler/Dockerfile to define the name of your Bot.  Below shows the line where it should be modified:
    RUN yo hubot --owner="Vinay <vinay@symphony.com>" --name="butler" --adapter="symphony" --defaults --no-insight

Whichever name you define for Bot in the /butler/Dockerfile should also be included in the /butler/stat.sh line shown below:
    bin/hubot -a symphony --name butler

## Build Container
To build the below container use the following:

    docker build -t butler:v1.0.0 .

## Run Container
To run the container use the following:

    docker run butler:v1.0.0

You can also run the container and include an external script folder. This will allow you to load new scripts at runtime of the container using the below:

    docker run -v /myfolder/scripts:/home/butler/scripts butler:v1.0.0
