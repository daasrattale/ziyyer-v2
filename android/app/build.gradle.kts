plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "dev.daasrattale.ziyyer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "dev.daasrattale.ziyyer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.mlkit:text-recognition:16.0.1")
}

// Ensure Flutter tooling can find the produced artifacts by copying them
// into the root `build/app/outputs/...` location after build.
tasks.register("copyDebugAab") {
    doLast {
        val src = file("$buildDir/outputs/bundle/debug/app-debug.aab")
        val destDir = File(rootProject.projectDir.parentFile, "build/app/outputs/bundle/debug")
        destDir.mkdirs()
        copy {
            from(src)
            into(destDir)
        }
    }
}

tasks.register("copyReleaseAab") {
    doLast {
        val src = file("$buildDir/outputs/bundle/release/app-release.aab")
        val destDir = File(rootProject.projectDir.parentFile, "build/app/outputs/bundle/release")
        destDir.mkdirs()
        copy {
            from(src)
            into(destDir)
        }
    }
}

afterEvaluate {
    tasks.matching { it.name == "bundleDebug" }.configureEach {
        finalizedBy(tasks.named("copyDebugAab"))
    }
    tasks.matching { it.name == "bundleRelease" }.configureEach {
        finalizedBy(tasks.named("copyReleaseAab"))
    }
}
