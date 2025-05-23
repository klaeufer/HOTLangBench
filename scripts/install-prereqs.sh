#!/bin/bash

sudo apt install -q -y ghc ocaml

curl -s "https://get.sdkman.io" | bash

. $HOME/.sdkman/bin/sdkman-init.sh

sdk install sbt

echo $HOME/.sdkman/candidates/sbt/current/bin >> $GITHUB_PATH
