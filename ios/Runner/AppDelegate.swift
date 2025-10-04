import Flutter
import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    // Set up MethodChannel to get 'Flavor' from Info.plist
    let controller = window?.rootViewController as? FlutterViewController ?? UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController
    if let controller = controller {
      let flavorChannel = FlutterMethodChannel(name: "flavor", binaryMessenger: controller.binaryMessenger)
      flavorChannel.setMethodCallHandler { call, result in
        if call.method == "getFlavor" {
          if let flavor = Bundle.main.object(forInfoDictionaryKey: "Flavor") as? String {
              print("Running in \(flavor) mode.")
              result(flavor)
          } else {
            result(FlutterError(code: "NO_FLAVOR", message: "Flavor not found", details: nil))
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
