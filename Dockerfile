FROM gcc:latest as build
COPY . /asteria_build
WORKDIR /asteria_build
RUN apt-get update
RUN apt-get -y install --no-install-recommends lua5.1 liblua5.1-dev zlib1g zlib1g-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
RUN make

FROM ubuntu as execution
# create base directories
RUN mkdir -p /home/asteria
RUN mkdir -p /home/asteria/scripts
WORKDIR /home/asteria
# copy the binary
COPY --from=build /asteria_build/asteria /home/asteria/asteria
# copy the compiled luac scripts
COPY --from=build /asteria_build/scripts/compiled /home/asteria/scripts/compiled
CMD ["./asteria"]