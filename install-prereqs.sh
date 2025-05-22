#!/bin/bash

sudo apt install -q -y g++ dotnet ghc golang ocaml cargo-1.80

curl -s "https://get.sdkman.io" | bash

. $HOME/.sdkman/bin/sdkman-init.sh

sdk install java 24-tem
sdk install sbt
