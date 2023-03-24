

# Ubuntu

## Installing Curl

A lot of software leverages curl to install these days.

```shell
apt-get install curl

# Reading package lists... Done
# Building dependency tree
# Reading state information... Done
# E: Unable to locate package curl
```

Requires an `apt-get update` first.

```shell
apt-get update; apt-get install curl

# :1 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
# :2 http://security.ubuntu.com/ubuntu focal-security InRelease [109 kB]
# :3 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
# ...
# After this operation, 16.7 MB of additional disk space will be used.
# Do you want to continue? [Y/n]
# ...
# Running hooks in /etc/ca-certificates/update.d...
# done.
```

