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
# create volume-backed directories if they do not exist
RUN mkdir -p /home/asteria/accounts
RUN mkdir -p /home/asteria/backup
RUN mkdir -p /home/asteria/backup/accounts
RUN mkdir -p /home/asteria/log
WORKDIR /home/asteria
# copy the binary
COPY --from=build /asteria_build/asteria /home/asteria/asteria
# copy the data containing flatfile db entries for items, skills, zones, monsters, etc.
COPY --from=build /asteria_build/data /home/asteria/data
# copy the compiled luac scripts
COPY --from=build /asteria_build/scripts/compiled /home/asteria/scripts/compiled
# copy the dynamically linked dependencies
COPY --from=build /usr/lib/x86_64-linux-gnu/liblua5.1.so.0 /usr/local/lib/liblua5.1.so.0
# inform 
ENV LD_LIBRARY_PATH=/usr/local/lib
CMD ["./asteria"]