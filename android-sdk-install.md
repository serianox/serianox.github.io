# Android _headless_ SDK installation

I wanted to install _Android SDK_ without installing this ugly IDE. The main goal was to rebuild existing projects, so I didn't need something as heavy. The main difficulty came when I downloaded the actual sdk, and receive the following message from Google.

> Because you've downloaded the command line tools (not Android Studio), there are no install instructions.

First things first. The SDK can be easily found on the download page of the Android developer website. Hidden at the end of the page in a section named _[Get just the command line tools](https://developer.android.com/studio/index.html#command-tools)_.

We download a `.zip` file, because it's to complicated to provide a tarball, and unzip it somewhere, preferably `~/.android`.

Then we update your `~/.profile`, or wherever we put your env to include the following lines _mutatis mutandis_ and reload our session.

```bash
export ANDROID_HOME="$HOME/.android"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
```

Once we're here, the installation is straightforward once we now which command to run.

```bash
android update sdk
```

Then we must install some build tools.

```bash
sdkmanager "platforms;android-23"
sdkmanager "build-tools;23.0.1"
```

And also we must not forget to install all those `compat` libraries.

```bash
sdkmanager "extras;android;m2repository"
```

And _voilà_!