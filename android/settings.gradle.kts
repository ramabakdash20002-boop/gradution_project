pluginManagement {
    // التغيير هنا: كتبنا الاسم بالكامل java.util.Properties عشان نضمن إنه يشتغل
    val properties = java.util.Properties()
    val localPropertiesFile = file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { properties.load(it) }
    }

    val flutterSdkPath = properties.getProperty("flutter.sdk")
    check(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    
    // النسخ الحديثة اللي ضبطناها مع بعض
    id("com.android.application") version "8.9.1" apply false
    id("com.android.library") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    
    // الفايربيز
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
