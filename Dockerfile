FROM gcc:latest as build
COPY . /asteria_docker
WORKDIR /asteria_docker/
RUN apt-get -y install --no-install-recommends lua5.1 liblua5.1-dev zlib1g zlib1g-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
RUN make

FROM scratch as execution
COPY --from=build /asteria_docker/asteria /bin/asteria
CMD ["bin/asteria"]