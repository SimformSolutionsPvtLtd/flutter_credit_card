import org.jetbrains.kotlin.gradle.dsl.JvmTarget

group = "com.simform.flutter_credit_card"
version = "1.0-SNAPSHOT"

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {

    // Conditional for compatibility with AGP < 4.2
    if (this::class.members.any { it.name == "namespace" }) {
        namespace = "com.simform.flutter_credit_card"
    }

    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("test").java.srcDirs("src/test/kotlin")
    }

    defaultConfig {
        minSdk = 16
    }
}
