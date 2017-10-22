# Ubuntu `dist-upgrade` aftermath

I wanted to upgrade my laptop from _Ubuntu Zeisty Zapus_ (17.04) to _Ubuntu Artful Aardvak_ (17.10). The process is usually pretty straightforward, and I am now lazy enough to do it from the gui. I started the upgrade and locked my computer as I left.

## First mistake

I quickly noticed that the lock screen was not working properly. One `Ctrl + F1` and `ps auxf` later confirmed my thought, as I saw that the dist upgrade process was running a task every 30s to prevent the lock screen from appearing.

A few minutes later, I could see that the upgrade process was nearly finished, but hanged as a graphical process was asking for a confirmation during a dpkg configure. I tried to kill the lockscreen or the configuration process, but nothing worked, and I was left with no solution but to force shutdown my latop.

## Second mistake

Upon reboot and after asking my passphrase to decrypt my harddrive, I was disappointed to notice that the boot process hanged. Without any way to know what was happening. Moreover, since my laptop has an UEFI, it was difficult to reboot to Grub in order to drop into a recovery shell.

From Grub, I was then able to reboot my laptop with a console output to discover what was going on. And it wasn't pretty. Some systemd daemon would fail to start due to cyclic dependencies in their configuration files, or respective dependencies.

Of course, it is perfectly fine to forbid login if the thermal sensor daemon fails to start.

![](ubuntu1.jpg)

## Repair

Fixing was pretty easy. Or it should have been. Or it was, before. Basically, one would spawn a recovery shell, then restarting `dpkg --configure -a` to finish OS configuration, and then reboot. 

However, the configuration process failed at some point. Some package where not configured due to an unconfigured dependency, _anacron_. Running `dpkg --configure`, then `ps auxf`, I saw that the configuration process was hanging on `systemd-tty-ask-password-agent`. Running as root. Headless.

I attempted to do the same, through _aptitude_ this time. Starting the network would fail, as `/etc/resolv.conf` was missing because systemd was not working. It was fun to repair name resolution, but this still wasn't enough to be able to reconnect to a wifi network.

## Success

I was ready to backup, reformat, reinstall. This was way faster than fixing this clusterfuck. However, after reconfiguring most of the packages, I was finally able to boot a non-working GDM up to login screen, which then started the wifi and reconnected to my home network. I immediatly returned to a tty, ran _aptitude_ to restart installation and configuration, and reboot with 50% chance of success. And I am now writting this on my newly installed _Artful Aardvak_

I still have no idea how I managed to pull this.

## Conclusion

First, for and end user, something as simple as an upgrade should not fail with something as simple as locking the screen.

Second, it is surprising that something as critical as the process of installing a core package should depend on something as complex and fragile as systemd. Even more as it was a hidden dependency.

I found firsthand that fixing systemd from a recovery shell is an impossible task. Either you are lucky, or you are left with reinstalling everything.

The only thing that helped me is that once you get through or around sytemd, you are still using a Unix. And you can still rely on something as robust as _dpkg_.

> User-friendly mon cul.
