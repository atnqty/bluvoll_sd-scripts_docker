FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update && apt install -y ffmpeg libsm6 libxext6 python3.10-venv git

RUN mkdir /docker-init
COPY init.sh /docker-init/init.sh
RUN chmod +x /docker-init/init.sh
WORKDIR /docker-init

SHELL ["/bin/bash", "--login", "-c"]
ENTRYPOINT [ "/docker-init/init.sh" ]
