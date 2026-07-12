package dev.daasrattale.ziyyer

import android.net.Uri
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class TextRecognitionPlugin(private val flutterEngine: FlutterEngine) : MethodChannel.MethodCallHandler {
    companion object {
        private const val CHANNEL = "dev.daasrattale.ziyyer/text_recognition"

        fun registerWith(flutterEngine: FlutterEngine) {
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            val plugin = TextRecognitionPlugin(flutterEngine)
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "recognizeText" -> {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath == null) {
                    result.error("INVALID_ARGS", "Missing imagePath", null)
                    return
                }
                recognizeText(imagePath, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun recognizeText(imagePath: String, result: MethodChannel.Result) {
        try {
            val file = File(imagePath)
            val uri = Uri.fromFile(file)
            val image = InputImage.fromFilePath(flutterEngine.applicationContext, uri)
            val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)

            recognizer.process(image)
                .addOnSuccessListener { visionText ->
                    result.success(visionText.text)
                }
                .addOnFailureListener { e ->
                    result.error("RECOGNITION_ERROR", e.message, null)
                }
        } catch (e: Exception) {
            result.error("IMAGE_ERROR", e.message, null)
        }
    }
}
