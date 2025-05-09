plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Plugin do Google Services
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter deve vir por último
}

android {
    namespace = "com.example.petloc01"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.petloc01"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

// 👇 Esta linha é essencial para o plugin funcionar corretamente
apply(plugin = "com.google.gms.google-services")
