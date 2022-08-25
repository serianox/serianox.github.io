# Using _Gadget Filesystem_ under _Ubuntu_

I wanted to emulate a USB device in Linux for testing purpose. This can be done easily using the [Gadget API](http://www.linux-usb.org/gadget/). However I quickly discovered that this feature was [not present in Ubuntu](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073089), even in the form of a kernel module in _linux-extra_. The only solution remaining was to rebuild the missing kernel module manually.

The main issue with a Linux kernel is that both the API and the ABI are not stable, meaning:

- You can't use any source version of the module. The kernel API is evolving and you are likely to miss new or deprecated API. The current version of the _dummy\_hcd_ module does not compile due to newly introduced APIs. The matching kernel source is available in the _linux-extra_ package.
- You can't keep a module you built for one version to another version. You must always rebuilt your module to match the current kernel ABI. Ideally the module must be known from _modprobe_ to be correctly loaded along its dependencies. This is solved by using _[DKMS](https://github.com/dell/dkms)_.

Now the proces was fairly simple.

1. Install the package `linux-source` to have the kernel sources matching the currently installed kernel.

This part is fairly easy.

```sh
sudo aptitude install linux-source
```

2. Setup a build process that would extract the source of the `dummy_hcd` kmod from these sources and,

For a Makefile, you can retrieve the current version of the kernel from `uname` plus some `grep`.

```Makefile
SVERSION := $(shell uname -r | grep -o "^[^-]*")
```

Then extract and move the `dummy_hcd.c` file from the current kernel source to the current folder.

```Makefile
dummy_hcd.c: /usr/src/linux-source-$(SVERSION)/linux-source-$(SVERSION).tar.bz2
tar -xjvf $^ linux-source-$(SVERSION)/drivers/usb/gadget/udc/dummy_hcd.c &&\
	cp linux-source-$(SVERSION)/drivers/usb/gadget/udc/dummy_hcd.c $@
```

3. Build the kmod using the kernel Makefile.

Following the basic example found in the documentation.

```Makefile
obj-m := dummy_hcd.o
KVERSION := $(shell uname -r)

all: dummy_hcd.c
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) modules

clean:
	$(MAKE) -C /lib/modules/$(KVERSION)/build M=$(PWD) clean
```

4. Wrap everything into a DKMS module.

First we should install DKMS.

```sh
sudo aptitude install dkms
```

Then add a `dkms.conf` to `ls /usr/src/dummy_hcd-0.1/` along with the Makefile we previously created.

```cfg
PACKAGE_NAME="dummy_hcd"
PACKAGE_VERSION="0.1"
CLEAN="make clean"
MAKE[0]="make all KVERSION=$kernelver"
BUILT_MODULE_NAME[0]="dummy_hcd"
DEST_MODULE_LOCATION[0]="/extra"
AUTOINSTALL="yes"
```

We can then add our DKMS module to be built and added to our kernel modules.

```sh
dkms add -m dummy_hcd -v 0.1
dkms build -m dummy_hcd -v 0.1
dkms install -m dummy_hcd -v 0.1
```

Finally, we can test our module is working by loading it and mounting the Gadget Filesystem.

```sh
modprobe dummy_hcd
mount -t gadgetfs gadgetfs /dev/gadgetfs
```

The complete project is published on [Github](https://github.com/serianox/DKMS-dummy_hcd).
