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
./volume_setup.sh
sudo docker compose up -d
```




This repository only ships with a threadbare deployment of sample rooms and items, and should not be considered a playable game.

# Next steps

1. Get a test framework working, so we can reproduce and fix crashers without gdb and ad-hoc testing.
2. Integrate Asteria's actual game data?
   1. If Arcades wills it, we'll set up a private github repo for the game data, and integrate it with the build pipeline.
   2. It might be a pleasant exercise to renovate the sample rooms we have in this repo, too, so that forks can be more easily written should anyone be so inspired.
