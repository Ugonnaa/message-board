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
cd /tmp

ls -la

echo "${GREETING}! I'm in $(pwd), I'm user $(whoami), and this operating system is based on $(uname)!"
