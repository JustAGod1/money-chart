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
RUN apt-get -y install libssl-dev libpq-dev pkg-config ca-certificates
RUN update-ca-certificates

RUN mkdir /work
WORKDIR /work

COPY --from=build /build/target/release/money-chart /work

CMD [ "/work/money-chart" ]