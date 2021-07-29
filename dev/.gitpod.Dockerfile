FROM eu.gcr.io/gitpod-core-dev/dev/dev-environment@sha256:659e304e80ed9d583908a8cecdf1e502ad77a6bfa0c772308d5973feaf9fc071
SHELL ["/bin/zsh", "-c"]

# install terraform
RUN sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt-get update && sudo apt-get install terraform

# Install required libraries for Projector + PhpStorm
RUN sudo apt-get -qq install -y python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6
# Install Projector
RUN pip3 install projector-installer
# Install IDEA
RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
# RUN projector ide install 'IntelliJ IDEA Ultimate 2020.3.2' --no-auto-run
RUN printf "2\nY\n3\n" | projector install --no-auto-run

# install dev tools
RUN brew install fd
RUN brew install fzf
RUN brew install ripgrep

RUN echo "alias intellij="~/.projector/configs/IntelliJ/run.sh $GITPOD_REPO_ROOT" >> /home/gitpod/.bashrc

# install google-cloud-sdk
ARG GCS_DIR=/opt/google-cloud-sdk
ENV PATH=$GCS_DIR/bin:$PATH
RUN sudo chown gitpod: /opt \
    && mkdir $GCS_DIR \
    && curl -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-344.0.0-linux-x86_64.tar.gz \
    | tar -xzvC /opt \
    && /opt/google-cloud-sdk/install.sh --quiet --usage-reporting=false --bash-completion=true \
    --additional-components docker-credential-gcr alpha beta \
    # needed for access to our private registries
    && docker-credential-gcr configure-docker
