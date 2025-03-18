plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
        import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("android/key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.GymTracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    val keystoreProperties = Properties().apply {
        val file = rootProject.file("key.properties")
        if (file.exists()) {
            load(FileInputStream(file))
        } else {
            println("⚠️ Warning: key.properties file not found! Using default values.")
        }
    }

    android {
        signingConfigs {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String?)
                storePassword = keystoreProperties["storePassword"] as String?
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
            }
        }

        buildTypes {
            release {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

}

flutter {
    source = "../.."
}
