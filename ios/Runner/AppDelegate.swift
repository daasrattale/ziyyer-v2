import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TextRecognitionPlugin") else { return }
    let channel = FlutterMethodChannel(name: "dev.daasrattale.ziyyer/text_recognition", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { (call, result) in
      guard call.method == "recognizeText",
            let args = call.arguments as? [String: Any],
            let imagePath = args["imagePath"] as? String else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.recognizeText(imagePath: imagePath, result: result)
    }
  }

  private func recognizeText(imagePath: String, result: @escaping FlutterResult) {
    let imageURL = URL(fileURLWithPath: imagePath)

    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
      result(FlutterError(code: "IMAGE_ERROR", message: "Could not load image", details: nil))
      return
    }

    let request = VNRecognizeTextRequest { request, error in
      if let error = error {
        result(FlutterError(code: "RECOGNITION_ERROR", message: error.localizedDescription, details: nil))
        return
      }

      guard let observations = request.results as? [VNRecognizedTextObservation] else {
        result("")
        return
      }

      let recognizedStrings = observations.compactMap { observation in
        observation.topCandidates(1).first?.string
      }

      result(recognizedStrings.joined(separator: "\n"))
    }

    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["en-US", "fr-FR", "es-ES"]
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    do {
      try handler.perform([request])
    } catch {
      result(FlutterError(code: "HANDLER_ERROR", message: error.localizedDescription, details: nil))
    }
  }
}
