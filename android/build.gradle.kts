allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Keep the default Gradle build directory to avoid confusing tools
// that expect the standard project layout. The project previously
// redirected the build directory to a location two levels up which
// can prevent the Flutter tooling from locating the generated APK.
// Leaving the default rootProject.layout.buildDirectory in place.

subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
