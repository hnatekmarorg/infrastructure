FROM python:3.7-bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN pip install ansible proxmoxer requests

RUN ansible-galaxy collection install community.general

RUN apt-get update && \
    apt-get install -y curl age openssh-client && \
    apt-get clean

RUN curl -sLS https://get.k3sup.dev | sh
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

RUN curl -sLS https://github.com/mozilla/sops/releases/download/v3.7.1/sops_3.7.1_amd64.deb > sops.deb && \
    dpkg -i sops.deb

RUN ssh-keygen -t ed25519 -C "docker@private"  -q -N "" -f /root/.ssh/id_ed25519

RUN curl -s https://fluxcd.io/install.sh | bash

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

WORKDIR /code

ADD . .

CMD task install