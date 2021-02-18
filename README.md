fapolicyd container
===

[fapolicyd](https://github.com/linux-application-whitelisting/fapolicyd) from podman

### build

`podman build -t fapolicyd .`

### run

`podman run --rm --name fapolicyd --privileged --systemd true -v /tmp:/deny -v $PWD/etc/simple.rules:/etc/fapolicyd/fapolicyd.rules fapolicyd`

### try

`podman exec -it fapolicyd bash -c '/deny/foo.sh'`

### check

`podman exec -it fapolicyd journalctl -u fapolicyd`
