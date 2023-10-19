Please be sure to read the handoff note by Greg, [readme.txt](readme.txt)

# Compiling and running

After cloning the repository, you will need zlib and lua 5.1.4 in order to build the project. In ubuntu, this requires gcc and looks like:

```
sudo apt install lua5.1 liblua5.1-dev zlib1g zlib1g-dev
ln -s /usr/lib/x86_64-linux-gnu/liblua5.1.so /usr/local/lib/liblua.so
```

To compile:
```
make
```

To clean:
```
make clean
```

To run the MUD:
```
./asteria
```

## Notes for debugging segfaults

Useful for getting almost-complete stack traces:
```
catchsegv ./asteria
```

# Using Docker

This will create volumes for the various folders required by asteria, and populate the data and zone folders with the contents of this repository.
```
s/volume_setup.sh
s/rebuild.sh
```

## Changing data and source files on the EC2 instance, live

Don't.

We use docker volumes to split the local file system from the data the mud actually uses in production. If you change, eg, data/item.db directly on /home/mud/ashyria-private, it will not do anything. Worse, it might break scripts meant to sync up our docker volumes with github.

## Saving OLC changes to github

Changes made inside the mud while the mud is running are stored in memory. When the mud saves them, it saves them to docker volumes. To copy from those docker volumes into the local repo and push to github, we use a script I've written.

Inside the mud:
```
dsave
```

This flushes mud memory to disk.

On the shell:
```
s/docker_olc.sh
```

This will move data from the volumes to the local copy of the repo, and push changes to the olc branch.

When you're sure you want to save olc changes long-term, you can perform the following commands on the shell:
```
git pull
git checkout olc
git rebase main
git checkout main
git merge --squash olc
git commit -m "OLC changes"
git push
```

This is only strictly necessary before restoring from backup or standing up a new copy of the mud somewhere.

## Restoring from backup / Standing up a new copy of the mud

If there are no existing volumes, the instructions are the same as previously mentioned
```
./volume_setup.sh
sudo docker compose up -d
```

If you want to wipe out the data and zones for whatever reason, and restore them from backup:
```
docker stop <running container>
docker rm
docker volume rm asteria_data asteria_zones
s/volume_setup.sh
s/rebuild.sh
```
