# Building Firefox in a chroot

Something I don't like is project with tons of build dependencies. They tend to stay and pollute the system. Something I don't like even more are containers.

Let's work with old school chroot.

## Installing dependencies

```
sudo aptitude install debootstrap schroot
```

## Installing an image

A recent version of Ubuntu is enough.

```
sudo debootstrap --variant=buildd arch=amd64 artful /srv/chroot/firefox-chroot http://archive.ubuntu.com/ubuntu/
```

## Configuring and starting the chroot

```
cat <<EOF > /etc/schroot/chroot.d/firefox.conf
[firefox]
description=Firefox
directory=/srv/chroot/firefox-chroot
users=user1
root-users=user1
type=directory
EOF
```

We need to enable write access to shared memory, else the build configuration tool will fail.

```
cat <<EOF >> /etc/schroot/default/fstab
/dev/shm        /dev/shm        none    rw,bind         0       0
EOF
```

## Configuring the image

The list of sources is missing some lines, so we must add them before installing dependencies. Moreover, the Firefox bootstrap forget to install Clang.

```
cat <<EOF >> /srv/chroot/firefox-chroot/etc/apt/sources.list
deb http://fr.archive.ubuntu.com/ubuntu/ artful-updates main restricted
deb http://fr.archive.ubuntu.com/ubuntu/ artful universe
deb http://fr.archive.ubuntu.com/ubuntu/ artful-updates universe
EOF
sudo schroot -c firefox
apt-get update
apt-get install python clang
exit
```

## Starting the chroot

```
schroot -c firefox
```

Now you can follow the [official build steps](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Simple_Firefox_build/Linux_and_MacOS_build_preparation).
