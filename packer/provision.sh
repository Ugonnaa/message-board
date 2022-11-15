#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

# Here put your build scripts, consider:

# How are you going to install your dependencies? (Node, anything that is 
# required for node to run, your npm dependencies) 
# Hint: this is a debian linux distribution, which uses the 'apt' package manager 
# for installing linux software packages https://linuxize.com/post/how-to-use-apt-command/

# Building the NextJS app, where is it going to live on the filesystem?

# which linux system user is going to run your app? who needs to own the files? (chown etc.)

# Random commands to see in build logs

echo $USER

sudo mv /tmp/app /app

sudo apt-get update

sudo apt-get install -y curl

sudo chown -R $USER:$USER /app

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 16

cd /app

npm install

npm run build
