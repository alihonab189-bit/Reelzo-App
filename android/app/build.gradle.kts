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
    // 🔥 Namespace and Application ID matching your Firebase
    namespace = "reelzo.honab.com" 
    
    // 🛠️ FIXED: Updated to 36 as required by your plugins
    compileSdk = 36 
    
    ndkVersion = "28.2.13676358"

    compileOptions {
        // ✅ FIXED: Enabled core library desugaring for local notifications
        isCoreLibraryDesugaringEnabled = true 
        
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: System.getenv("KEY_ALIAS")
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: System.getenv("KEY_PASSWORD")
            storePassword = keystoreProperties.getProperty("storePassword") ?: System.getenv("STORE_PASSWORD")
            
            val storeFilePath = keystoreProperties.getProperty("storeFile") ?: "upload-keystore.jks"
            storeFile = file(storeFilePath)
        }
    }

    defaultConfig {
        applicationId = "reelzo.honab.com" 
        minSdk = 24 
        
        // 🛠️ FIXED: Updated to 36 to match compileSdk
        targetSdk = 36 
        
        multiDexEnabled = true
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            
            isMinifyEnabled = true
            isShrinkResources = true
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"), 
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // ✅ FIXED: Added desugar library dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}