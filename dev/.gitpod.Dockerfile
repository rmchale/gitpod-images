#FROM eu.gcr.io/gitpod-core-dev/dev/dev-environment@sha256:659e304e80ed9d583908a8cecdf1e502ad77a6bfa0c772308d5973feaf9fc071
FROM eu.gcr.io/gitpod-core-dev/dev/dev-environment:0.10.0
#FROM eu.gcr.io/gitpod-core-dev/dev/dev-environment:main.1888
SHELL ["/bin/zsh", "-c"]

# install terraform
RUN sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt-get update && sudo apt-get install terraform

# install dev tools
RUN brew install fd
RUN brew install fzf
RUN brew install ripgrep
RUN brew install micronaut
RUN brew install direnv
RUN brew install glab

RUN pip3 install pipreqs

# upgrade aws-cli
RUN pip3 install awscli --upgrade

# install jupyter
# RUN brew install jupyterlab

# RUN echo "alias intellij='~/.projector/configs/IntelliJ/run.sh $GITPOD_REPO_ROOT'" >> /home/gitpod/.bashrc
RUN echo "eval \"\$(direnv hook bash)\"" >> /home/gitpod/.bashrc

# Install required libraries for Projector + PhpStorm
RUN sudo apt-get -qq install -y python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6
# Install Projector
# RUN pip3 install projector-installer
# Install IDEA
# RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
# RUN projector ide install 'IntelliJ IDEA Ultimate 2020.3.4' --no-auto-run
# RUN printf "2\nY\n4\n" | projector install --no-auto-run

# install SERVERLESS
# RUN curl -o- -L https://slss.io/install | bash

# install SDK man
# RUN curl -s "https://get.sdkman.io" | bash
# RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk selfupdate
# RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install micronaut 3.0.1
# RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java 16.0.2-zulu
