## Get initrd and kernel

```
docker run --rm -v ${PWD}/target/:/target/:rw docker-registry.csikoste.com/pi-k3s-deploy-pi64:tag
```

## Extract initrd

```
zcat target/initrd.cpio.gz | cpio -idv --no-absolute-filenames --directory extract
```
