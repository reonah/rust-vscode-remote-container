# syntax=docker/dockerfile:1.4

# https://gallery.ecr.aws/docker/library/rust
FROM public.ecr.aws/docker/library/rust:1.61.0-slim as build

LABEL maintainer "reona.hoshino <dev.reona.hoshino+github@gmail.com>" 

ARG GO_VER=1.17.7
ARG PYTHON_VER=3.9

WORKDIR /build

# some tools
RUN <<Tools
    apt-get update -y
    apt-get install -y --no-install-recommends git vim curl unzip jq lldb python${PYTHON_VER} python3-pip
    pip3 --no-cache-dir install cfn-lint
    apt-get clean
    rm -rf /var/lib/apt/list/*
Tools

# sam cli
RUN <<Sam
    curl -L https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -o samcli.zip
    unzip samcli.zip -d sam-installation
    chomod +x ./sam-installation/install
    ./sam-installation/install
Sam

# aws cli
RUN <<Awscli
    curl -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
    unzip awscliv2.zip
    chmod +x ./aws/install
    ./aws/install
Awscli

# go
RUN <<Go
    curl -L https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz -o go.tar.gz
    tar -xzf go.tar.gz -C /usr/local
Go

ENV GOROOT=/usr/local/go
ENV GOPATH=/usr/go
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin
ENV GO111MODULE=on


# task: https://github.com/go-task/task
# rain: https://github.com/aws-cloudformation/rain
RUN <<GoTools
    go install github.com/go-task/task/v3/cmd/task@latest
    go install github.com/aws-cloudformation/rain/cmd/rain@main
GoTools

# git: https://github.com/git/git
# rain: https://github.com/aws-cloudformation/rain
RUN <<CommandCompletion
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /root/git-prompt.sh
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /root/git-completion.bash
    curl https://raw.githubusercontent.com/aws-cloudformation/rain/main/docs/bash_completion.sh -o /root/rain_completion.sh
CommandCompletion

# hadolint
RUN <<hadolint
    curl -L https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64 -o /usr/bin/hadolint
    chmod +x /usr/bin/hadolint
hadolint

FROM public.ecr.aws/docker/library/rust:1.61.0-slim
LABEL maintainer "reona.hoshino <dev.reona.hoshino+github@gmail.com>" 

COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /usr/local/aws-sam-cli/ /usr/local/aws-sam-cli/
COPY --from=build /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=build /usr/bin/hadolint /usr/bin/hadolint
COPY --from=build /usr/bin/git /usr/bin/git
COPY --from=build /usr/bin/jq /usr/bin/jq
COPY --from=build /usr/bin/vim /usr/bin/vim
COPY --from=build /usr/bin/which /usr/bin/which
COPY --from=build /usr/go/bin/ /usr/go/bin/
COPY --from=build /lib/ /lib/
COPY --from=build /usr/lib/ /usr/lib/
COPY --from=build /usr/bin/python3.9 /usr/bin/python3.9
COPY --from=build /usr/bin/python3 /usr/bin/python3
COPY --from=build /usr/local/lib/python3.9/ /usr/local/lib/python3.9/
COPY --from=build /root/git-prompt.sh /root/git-prompt.sh
COPY --from=build /root/git-completion.bash /root/git-completion.bash
COPY --from=build /root/rain_completion.sh /root/rain_completion.sh

ENV SHELL=/bin/bash
ENV GOPATH=/usr/go
ENV PATH=$PATH:$GOPATH/bin
