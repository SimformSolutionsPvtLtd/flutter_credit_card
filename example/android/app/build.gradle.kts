import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use {
        localProperties.load(it)
    }
}

val flutterVersionCode =
        localProperties.getProperty("flutter.versionCode") ?: "1"

val flutterVersionName =
        localProperties.getProperty("flutter.versionName") ?: "1.0"

android {

    // Compatibility with AGP < 4.2
    if (this::class.members.any { it.name == "namespace" }) {
        namespace = "com.simform.example"
    }

    compileSdk = 35

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    lint {
        disable.add("InvalidPackage")
    }

    defaultConfig {
        applicationId = "com.simform.example"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        testInstrumentationRunner =
                "android.support.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    testImplementation("junit:junit:4.12")
    androidTestImplementation("com.android.support.test:runner:1.0.2")
    androidTestImplementation("com.android.support.test.espresso:espresso-core:3.0.2")
}
