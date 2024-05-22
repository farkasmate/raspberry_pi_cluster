ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION} as INITRD

ARG EXTRA_MODULES=''
ARG KERNEL_PKG=linux-lts

WORKDIR /build/

COPY add-modules /usr/local/bin/add-modules
COPY init ./
COPY rootfs/etc/resolv.conf ./etc/resolv.conf

RUN mkdir -p ./bin/ ./lib/modules/ /lib/modules/ /out/ \
    && apk fetch --no-cache --output /tmp/ \
      ${KERNEL_PKG} \
      busybox \
      kmod-libs \
      libcrypto3 \
      musl \
      open-iscsi \
      open-iscsi-libs \
      xz-libs \
      zlib \
      zstd-libs \
    && tar xf /tmp/${KERNEL_PKG}-*.apk -C /tmp/ boot/ lib/modules/ \
    && tar xf /tmp/busybox-[[:digit:]]*.apk bin/ \
    && tar xf /tmp/kmod-libs-*.apk lib/ \
    && tar xf /tmp/libcrypto3-*.apk lib/ \
    && tar xf /tmp/musl-*.apk lib/ \
    && tar xf /tmp/open-iscsi-[[:digit:]]*.apk -C ./bin/ --strip-components 2 usr/sbin/iscsistart \
    && tar xf /tmp/open-iscsi-libs-*.apk --strip-components 1 usr/lib/ \
    && tar xf /tmp/xz-libs-*.apk --strip-components 1 usr/lib/ \
    && tar xf /tmp/zlib-*.apk lib/ \
    && tar xf /tmp/zstd-libs-*.apk --strip-components 1 usr/lib/ \
    && ln -s /tmp/lib/modules/* /lib/modules/$(uname -r) \
    && add-modules \
      ${EXTRA_MODULES} \
      crc32c_generic \
      ext4 \
      iscsi_tcp \
      sd_mod \
    && find . -print0 | cpio --create --format newc --null --owner 0:0 --quiet | gzip > /out/initrd.cpio.gz

FROM alpine:${ALPINE_VERSION} as ROOTFS

WORKDIR /build/

COPY --from=INITRD /tmp/lib/modules ./lib/modules

COPY rootfs ./

RUN mkdir -p /out/ \
    && apk add --root ./ --keys-dir /etc/apk/keys/ --repositories-file /etc/apk/repositories --initdb \
      alpine-baselayout \
      blkid \
      busybox-openrc \
      ca-certificates-bundle \
      dropbear \
      dropbear-openrc \
      eudev \
      k3s \
      k3s-openrc \
      open-iscsi \
    && rm -rf ./etc/apk/ ./lib/apk/ ./var/cache/apk/ \
    && chmod -R go-rwx ./root/ \
    && find . -print0 | cpio --create --format newc --null --owner 0:0 --quiet | gzip > /out/rootfs.cpio.gz

FROM busybox:latest as DATAFS

WORKDIR /build/

COPY datafs ./

RUN mkdir -p /out/ \
    && find . ! -name .gitkeep -print0 | cpio --create --format newc --null --owner 0:0 --quiet | gzip > /out/datafs.cpio.gz

FROM busybox:latest as DEPLOY

WORKDIR /deploy/

COPY --from=INITRD /out/initrd.cpio.gz ./initrd.cpio.gz
COPY --from=INITRD /tmp/boot/vmlinuz-* ./kernel8.img

COPY --from=ROOTFS /out/rootfs.cpio.gz ./rootfs.cpio.gz

COPY --from=DATAFS /out/datafs.cpio.gz ./datafs.cpio.gz

CMD cp * /target/
