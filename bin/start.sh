#! /bin/bash

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
rvm --default use 1.9.3

ruby server.rb > server.log 2>&1 &
