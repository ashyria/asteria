FROM gcc:latest as build
COPY . /asteria_build
WORKDIR /asteria_build
RUN apt-get update
RUN apt-get -y install --no-install-recommends lua5.1 liblua5.1-dev zlib1g zlib1g-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
RUN make

FROM ubuntu as execution
RUN mkdir -p /home/asteria
RUN mkdir -p /home/asteria/accounts
RUN mkdir -p /home/asteria/backup
RUN mkdir -p /home/asteria/backup/accounts
RUN mkdir -p /home/asteria/data
RUN mkdir -p /home/asteria/log
RUN mkdir -p /home/asteria/scripts
WORKDIR /home/asteria
COPY --from=build /asteria_build/asteria /home/asteria/asteria
COPY --from=build /asteria_build/scripts/compiled /home/asteria/scripts/compiled
COPY --from=build /usr/lib/x86_64-linux-gnu/liblua5.1.so.0 /usr/local/lib/liblua5.1.so.0
ENV LD_LIBRARY_PATH=/usr/local/lib
CMD ["./asteria"]