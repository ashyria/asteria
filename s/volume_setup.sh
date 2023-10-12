#!/bin/bash
# the accounts and log directories are allowed to be empty
docker volume create asteria_accounts
docker volume create asteria_log

# the backup directory requires an empty accounts subdirectory
mkdir -p $PWD/backup
mkdir -p $PWD/backup/accounts
pushd $PWD/backup
docker run --rm -v $PWD:/source -v asteria_data:/dest -w /source alpine cp -r * /dest
popd

# the data and zones directories require data from the distro
pushd $PWD/data
docker run --rm -v $PWD:/source -v asteria_data:/dest -w /source alpine cp -r * /dest
popd
pushd $PWD/zones
docker run --rm -v $PWD:/source -v asteria_zones:/dest -w /source alpine cp -r * /dest
popd