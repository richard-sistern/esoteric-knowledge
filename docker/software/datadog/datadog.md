# DataDog

I wanted to take a look at DataDog but didn't wish to install agents everywhere.  Thought I would give containers a go for testing...

First step, signup to the DataDog 14 day trial.  This will provide you with a custom command to install the Ubuntu agent.  There is a Docker specific agent, but that provides host metrics and isn't what we want here.

Start an Ubuntu container with interactive terminal.

```shell
docker container run -it ubuntu

# Unable to find image 'ubuntu:latest' locally
# latest: Pulling from library/ubuntu
# 345e3491a907: Pull complete
# 57671312ef6f: Pull complete
# 5e9250ddb7d0: Pull complete
# Digest: sha256:cf31af331f38d1d7158470e095b132acd126a7180a54f263d386da88eb681d93
# Status: Downloaded newer image for ubuntu:latest
```

Install Curl.

```bash
apt-get update && apt-get install curl
```

Install the DataDog agent for Ubuntu.

```bash
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=1101pew10pew10pew DD_SITE="datadoghq.eu" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
```
*Note: the agents page on the DataDog website will specify your own DD_API_KEY*

The agent will report back to DataDog in a minute or two.  In the meantime install a stress testing tool.

```bash
apt-get install stress
```

Lets add some CPU load.

```bash
stress --cpu 3
# stress: info: [7081] dispatching hogs: 3 cpu, 0 io, 0 vm, 0 hdd

# wait a few minutes...
# CTRL + C

stress --cpu 4
# stress: info: [7685] dispatching hogs: 4 cpu, 0 io, 0 vm, 0 hdd
```

Navigate to the `System - Metrics` dashboard in DataDog.  The `CPU usage (%)` should now show the system under load.

![datadog_cpu](/assets/datadog_cpu.png)

