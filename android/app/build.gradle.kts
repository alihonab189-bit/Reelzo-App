import java.util.Properties
import java.io.FileInputStream

// Load keystore properties from local file if it exists
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 🔥 Updated to match your Firebase package name
    namespace = "reelzo.honab.com" 
    compileSdk = 35 
    
    // Optimized NDK version for 2026 stable builds
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    signingConfigs {
        create("release") {
            // Support for both local build and GitHub Actions secrets
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: System.getenv("KEY_ALIAS")
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: System.getenv("KEY_PASSWORD")
            storePassword = keystoreProperties.getProperty("storePassword") ?: System.getenv("STORE_PASSWORD")
            
            // Expected keystore file name in GitHub runner
            val storeFilePath = keystoreProperties.getProperty("storeFile") ?: "upload-keystore.jks"
            storeFile = file(storeFilePath)
        }
    }

    defaultConfig {
        // 🔥 Critical: Must match your Firebase console configuration
        applicationId = "reelzo.honab.com" 
        minSdk = 24 
        targetSdk = 35 
        multiDexEnabled = true
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Link to the release signing config created above
            signingConfig = signingConfigs.getByName("release")
            
            // Performance optimizations for 3GB RAM devices
            isMinifyEnabled = true
            isShrinkResources = true
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"), 
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}