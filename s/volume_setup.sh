#!/bin/bash
docker volume create asteria_accounts
docker volume create asteria_backup
docker volume create asteria_log

pushd $PWD/data
docker run --rm -v $PWD:/source -v asteria_data:/dest -w /source alpine cp -r * /dest
popd
pushd $PWD/zones
docker run --rm -v $PWD:/source -v asteria_zones:/dest -w /source alpine cp -r * /dest
popd