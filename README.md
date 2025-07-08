# dig-buildkit-rootless-permissions

reproduce:

```
export DOCKER_REPO=docker.io/whatever_you_can_push_on
mkdir $HOME/.docker.test && touch 
touch $HOME/.docker.test/config.json # fill it correctly so that you can push on DOCKER_REPO
bash reproduce.sh
```

output:

```
+ docker run -it --rm buildkit-generated:copy-simple /bin/bash -c 'ls -alhd /tmp'
drwxrwxrwt 1 root root 4.0K Jul  8 12:04 /tmp
+ docker run -it --rm buildkit-generated:copy-link /bin/bash -c 'ls -alhd /tmp'
drwxr-sr-x 1 root root 4.0K Jul  8 12:05 /tmp
+ docker run -it --rm buildkit-generated:no-copy /bin/bash -c 'ls -alhd /tmp'
drwxrwxrwt 2 root root 4.0K Jun 30 00:00 /tmp
```

