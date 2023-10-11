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

```
sudo docker build -t asteria .
sudo docker run --restart=on-failure -d -p 1111:1111 asteria
```

or, and I'm doubly uncertain what I'm doing here:

```
sudo docker compose up -d
```

This repository only ships with a threadbare deployment of sample rooms and items, and should not be considered a playable game.

# Next steps

1. Build pipeline, possibly using docker compose
   1. Definitely need volumes for re-used data
      1. accounts
      2. backup
      3. log
      4. copyover.dat, which doesn't live in a directory yet
2. Get a test framework working, so we can reproduce and fix crashers without gdb and ad-hoc testing.
3. Integrate Asteria's actual game data?
   1. If Arcades wills it, we'll set up a private github repo for the game data, and integrate it with the build pipeline.
   2. It might be a pleasant exercise to renovate the sample rooms we have in this repo, too, so that forks can be more easily written should anyone be so inspired.
