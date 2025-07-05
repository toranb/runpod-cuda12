ARG ELIXIR_VERSION=1.18.2
ARG OTP_VERSION=27.2.2
ARG DEBIAN_VERSION=bullseye-20250203

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE}

RUN apt-get update -y && apt-get install -y build-essential cmake git vim tmux erlang-dev \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN apt update -q && apt install -y ca-certificates wget && \
    wget -qO /cuda-keyring.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i /cuda-keyring.deb && apt update -q

RUN apt-get install -y cuda-nvcc-12-9 cuda-libraries-12-9 libcudnn9-cuda-12

RUN apt-get update && apt-get install -y openssh-server

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV XLA_TARGET="cuda12"

EXPOSE 22

CMD ["entrypoint.sh"]
