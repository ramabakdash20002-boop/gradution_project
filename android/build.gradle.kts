// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // في Kotlin DSL يجب استخدام الأقواس وعلامات التنصيص المزدوجة
        classpath("com.android.tools.build:gradle:8.1.4")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.20")
        classpath("com.google.gms:google-services:4.4.1") 
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// إعداد مسار الـ Build
rootProject.layout.buildDirectory.set(file("${project.projectDir}/../build"))
subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}

// 💡 الكود ده هو الحل النهائي لمشكلة tflite_v2 و Namespace (نسخة Kotlin DSL)
// بيجبر المكتبات القديمة إنها تاخد Namespace عشان الـ Build ميفشلش
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as? com.android.build.gradle.BaseExtension
            if (android?.namespace == null) {
                android?.namespace = project.group.toString()
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
