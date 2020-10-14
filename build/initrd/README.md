## Get initrd and kernel

```
docker run --rm -it --name temp docker-registry.csikoste.com/initrd-deploy:e08ebd1-dirty
```

```
docker cp temp:/out/initrd.cpio.gz .
docker cp temp:/out/vmlinuz-lts kernel8.img
```

## Extract initrd

```
zcat initrd.cpio.gz | cpio -idv --no-absolute-filenames
```
