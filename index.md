# make blog



<!-- TOC -->
* 2018-02-18 [Building Firefox in a chroot](firefox-build-debootstrap.html)

Something I don't like is project with tons of build dependencies. They tend to stay and pollute the system. Something I don't like even more are containers.

* 2017-10-22 [Ubuntu `dist-upgrade` aftermath](ubuntu-dist-upgrade-aftermath.html)

I wanted to upgrade my laptop from _Ubuntu Zeisty Zapus_ (17.04) to _Ubuntu Artful Aardvak_ (17.10). The process is usually pretty straightforward, and I am now lazy enough to do it from the gui. I started the upgrade and locked my computer as I left.

* 2017-08-13 [Using _Gadget Filesystem_ under _Ubuntu_](gadgetfs-ubuntu.html)

I wanted to emulate a USB device in Linux for testing purpose. This can be done easily using the [Gadget API](http://www.linux-usb.org/gadget/). However I quickly discovered that this feature was [not present in Ubuntu](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073089), even in the form of a kernel module in _linux-extra_. The only solution remaining was to rebuild the missing kernel module manually.

* 2017-05-23 [Manually migrating an Android project to Kotlin](android-kotlin-migration.html)

Kotlin is now officialy [Kotlin and Android](https://developer.android.com/kotlin/index.html), and as such I wanted to give it another try. There are of course tutorials [out there](https://kotlinlang.org/docs/tutorials/kotlin-android.html), but they all aim users of Android Studio. Let's see how we can do without.

* 2017-05-08 [Android _headless_ SDK installation](android-sdk-install.html)

I wanted to install _Android SDK_ without installing this ugly IDE. The main goal was to rebuild existing projects, so I didn't need something as heavy. The main difficulty came when I downloaded the actual sdk, and receive the following message from Google.

* 2017-03-13 [make blog](index.html)



<!-- TOC -->

```c
#include <stdio.h>

int main(void)
{
  printf("Hello world\n");
  return 0;
}
```
```rust
fn main() {
    println!("Hello, world!");
}
```
```javascript
interface Console {
    log(message?: any, ...optionalParams: any[]): void;
}

console.log("Hello, world!")
```
```haskell
main = putStrLn "Hello, world!"
```
