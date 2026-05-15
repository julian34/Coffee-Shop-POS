allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    val isBluetoothThermal = name == "print_bluetooth_thermal"
    if (!isBluetoothThermal) {
        plugins.withId("com.android.library") {
            extensions.configure<com.android.build.api.dsl.LibraryExtension> {
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
    }
    tasks.withType<org.gradle.api.tasks.compile.JavaCompile>().configureEach {
        if (!isBluetoothThermal) {
            sourceCompatibility = JavaVersion.VERSION_17.toString()
            targetCompatibility = JavaVersion.VERSION_17.toString()
        }
    }
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions.jvmTarget =
            if (isBluetoothThermal) {
                JavaVersion.VERSION_1_8.toString()
            } else {
                JavaVersion.VERSION_17.toString()
            }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
