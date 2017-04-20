#!/bin/sh

qemu-system-x86_64 -enable-kvm -smp 2 -m 1500 -netdev user,id=mynet0,hostfwd=tcp::8022-:22,hostfwd=tcp::8090-:80 -device virtio-net-pci,netdev=mynet0 -vga qxl -drive file=dcrs.img,format=raw
