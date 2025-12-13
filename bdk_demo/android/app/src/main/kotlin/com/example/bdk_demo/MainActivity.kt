package com.example.bdk_demo

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.util.zip.ZipFile

private const val CHANNEL = "bdk_demo/native_lib_dir"

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getNativeLibDir" -> {
                        val path = findLibDirectory()
                        if (path != null) {
                            result.success(path)
                        } else {
                            result.error(
                                "LIB_NOT_FOUND",
                                "Could not locate libbdkffi.so in nativeLibraryDir",
                                null
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun findLibDirectory(): String? {
        val info = applicationContext.applicationInfo
        val nativeDirPath = info.nativeLibraryDir ?: return null
        val baseDir = File(nativeDirPath)
        if (!baseDir.exists()) {
            Log.w("BDKDemo", "nativeLibraryDir does not exist: $nativeDirPath")
            return null
        }

        val direct = File(baseDir, "libbdkffi.so")
        if (direct.exists()) {
            return baseDir.absolutePath
        }

        baseDir.listFiles()?.forEach { candidateDir ->
            if (!candidateDir.isDirectory) return@forEach

            val candidate = File(candidateDir, "libbdkffi.so")
            if (candidate.exists()) {
                return candidateDir.absolutePath
            }

            candidateDir.listFiles()?.forEach { nestedDir ->
                if (!nestedDir.isDirectory) return@forEach
                val nestedCandidate = File(nestedDir, "libbdkffi.so")
                if (nestedCandidate.exists()) {
                    return nestedDir.absolutePath
                }

                nestedDir.listFiles()?.forEach { innerDir ->
                    if (!innerDir.isDirectory) return@forEach
                    val innerCandidate = File(innerDir, "libbdkffi.so")
                    if (innerCandidate.exists()) {
                        return innerDir.absolutePath
                    }
                }
            }
        }

        Build.SUPPORTED_ABIS?.forEach { abi ->
            val candidateDir = File(baseDir, abi)
            val candidate = File(candidateDir, "libbdkffi.so")
            if (candidate.exists()) {
                return candidateDir.absolutePath
            }
        }

        val extracted = extractLibraryFromApk()
        if (extracted != null) {
            return extracted
        }

        return null
    }

    private fun extractLibraryFromApk(): String? {
        val info = applicationContext.applicationInfo
        val apkPath = info.sourceDir ?: return null
        val supportedAbis = Build.SUPPORTED_ABIS ?: return null
        val destRoot = File(applicationContext.filesDir, "bdk_native_libs")

        if (!destRoot.exists() && !destRoot.mkdirs()) {
            Log.w("BDKDemo", "Failed to create destination dir: ${destRoot.absolutePath}")
            return null
        }

        try {
            ZipFile(apkPath).use { zip ->
                for (abi in supportedAbis) {
                    val entryName = "lib/$abi/libbdkffi.so"
                    val entry = zip.getEntry(entryName) ?: continue

                    val abiDir = File(destRoot, abi)
                    if (!abiDir.exists() && !abiDir.mkdirs()) {
                        Log.w("BDKDemo", "Failed to create ABI dir: ${abiDir.absolutePath}")
                        continue
                    }

                    val outputFile = File(abiDir, "libbdkffi.so")
                    if (outputFile.exists()) {
                        return abiDir.absolutePath
                    }

                    zip.getInputStream(entry).use { input ->
                        FileOutputStream(outputFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                    outputFile.setReadable(true, false)
                    return abiDir.absolutePath
                }
            }
        } catch (e: IOException) {
            Log.e("BDKDemo", "Failed to extract libbdkffi.so", e)
        }

        return null
    }
}
