# syntax=docker/dockerfile:1.4

# https://gallery.ecr.aws/docker/library/rust
FROM public.ecr.aws/docker/library/rust:1.61.0-slim as build

LABEL maintainer "reona.hoshino <dev.reona.hoshino+github@gmail.com>" 

WORKDIR /build

# some tools
RUN apt-get update -y &&\
    apt-get install -y --no-install-recommends git vim curl unzip jq lldb libssl-dev pkg-config &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/list/*

RUN rustup component add rustfmt clippy rust-analysis rust-src &&\
    cargo install cargo-edit

# task runner
RUN  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# git 補完
RUN curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /root/git-prompt.sh &&\
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /root/git-completion.bash &&\
    curl https://raw.githubusercontent.com/aws-cloudformation/rain/main/docs/bash_completion.sh -o /root/rain_completion.sh

#hadolint
RUN curl -L https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64 -o /usr/bin/hadolint &&\
    chmod +x /usr/bin/hadolint


FROM public.ecr.aws/docker/library/rust:1.61.0-slim
LABEL maintainer "reona.hoshino <dev.reona.hoshino+github@gmail.com>" 

COPY --from=build /usr/local/cargo/ /usr/local/cargo/
COPY --from=build /usr/local/rustup/ /usr/local/rustup/
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /usr/bin/hadolint /usr/bin/hadolint
COPY --from=build /usr/bin/git /usr/bin/git
COPY --from=build /usr/bin/jq /usr/bin/jq
COPY --from=build /usr/bin/vim /usr/bin/vim
COPY --from=build /usr/bin/which /usr/bin/which
COPY --from=build /lib/ /lib/
COPY --from=build /usr/lib/ /usr/lib/
COPY --from=build /root/git-prompt.sh /root/git-prompt.sh
COPY --from=build /root/git-completion.bash /root/git-completion.bash
ENV SHELL=/bin/bash
