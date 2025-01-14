FROM ubuntu:latest

EXPOSE 8555
EXPOSE 8444

ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address="null"
ENV farmer_port="null"
ENV testnet="false"
ENV full_node_port="null"
ENV BRANCH="1.1.6"

RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y curl jq python3 ansible tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils apt nfs-common python-is-python3 vim tzdata

RUN echo "cloning chia-blockchain branch ${BRANCH}"
RUN git clone --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git && cd chia-blockchain && git submodule update --init mozilla-ca && chmod +x install.sh && /usr/bin/sh ./install.sh

RUN echo "Downloading chiabot latest release"
RUN mkdir /root/.chia && cd /root/.chia && wget https://github.com/joaquimguimaraes/chiabot/releases/download/v1.2.7-1/chiabot-linux-amd64.tar.gz && tar -xvzf chiabot-linux-amd64.tar.gz

WORKDIR /chia-blockchain
ADD ./entrypoint.sh entrypoint.sh

ENTRYPOINT ["bash", "./entrypoint.sh"]
