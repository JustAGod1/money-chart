FROM debian:12.6 as build

RUN apt-get update
RUN apt-get -y install curl build-essential libssl-dev libpq-dev pkg-config

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN mkdir /build
WORKDIR /build

COPY . .

RUN cargo build --release


FROM debian:12.6 as run

RUN apt-get update
RUN apt-get -y install libssl-dev libpq-dev pkg-config ca-certificates curl bash xz-utils
RUN update-ca-certificates

RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/diesel-rs/diesel/releases/download/v2.2.1/diesel_cli-installer.sh | sh
ENV PATH="/root/.cargo/bin:${PATH}"

RUN mkdir /work
RUN mkdir /diesel
WORKDIR /work

COPY --from=build /build/target/release/money-chart /work
COPY . /diesel

CMD /bin/bash -c "cd /diesel && diesel setup && cd /work && /work/money-chart" 