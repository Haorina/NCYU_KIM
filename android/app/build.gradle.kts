plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ncyu_kim"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.ncyu_kim"
        minSdk = 28
        targetSdk = 33
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    // 加入這行：讓 release 用 debug key
    buildTypes {
        named("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")  // 關鍵！
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
        }
        named("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packaging {
        resources {
            pickFirsts.addAll(
                listOf(
                    "**/libc++_shared.so",
                    "**/libjsc.so"
                )
            )
        }
    }

    sourceSets {
        named("main") {
            assets.srcDirs(
                "src/main/assets",
                "../assets"
            )
        }
    }
}

dependencies {
    implementation("com.google.mediapipe:tasks-vision:0.10.28")
    implementation("com.google.mediapipe:tasks-core:0.10.28")
}

flutter {
    source = "../.."
}