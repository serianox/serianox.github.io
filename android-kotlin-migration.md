# Manually migrating an Android project to Kotlin

Kotlin is now officialy part of the Android SDK[^1], and as such I wanted to give it another try. There are of course tutorials out there[^2], but they all aim users of Android Studio. Let's see how we can do without.

[^1]: [Kotlin and Android](https://developer.android.com/kotlin/index.html)

[^2]: [https://kotlinlang.org/docs/tutorials/kotlin-android.html](https://kotlinlang.org/docs/tutorials/kotlin-android.html)

First things first, let's add Kotlin to our build script. We need to add to the `build.gradle` of our application three things:

- the repository where Kotlin is found,
- the dependency to the build tools for Kotlin,
- the runtime dependencies for our project.

```diff
buildscript {
+    repositories {
+        jcenter()
+        mavenCentral()
+    }
+    dependencies {
+        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.1.2"
+    }
+}
+
 apply plugin: 'com.android.application'
+apply plugin: 'kotlin-android'
+apply plugin: 'kotlin-android-extensions'
```

```diff
 dependencies {
     compile fileTree(dir: 'libs', include: ['*.jar'])
     compile 'com.android.support:design:23.1.1'
+
+    compile 'org.jetbrains.kotlin:kotlin-stdlib:1.1.2'
+    testCompile 'org.jetbrains.kotlin:kotlin-stdlib:1.1.2'
 }
```

If we run our `gradlew` script, we can see that it is installing the Kotlkin toolchain, but that no Kotlin code is built. Of course, because there are none yet.

Kotlin developers provide an online Java-to-Kotlkin transpiler[^3]. It is far from perfect, but it is enough for beginers with an existing Java project. In our application source directory, we create the same architecture where we replace `src/main/java/<package>` with `src/main/kotlin/<package>`. We transpile all the `.java` files to `.kt` and we run again our ` gradlew` script.

[^3]: [Try Kotlin](https://try.kotlinlang.org/)

Voilà.
