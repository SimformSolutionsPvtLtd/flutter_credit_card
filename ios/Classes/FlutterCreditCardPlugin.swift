import Flutter
import UIKit

public class FlutterCreditCardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.simform.flutter_credit_card/methods", binaryMessenger: registrar.messenger())
    let instance = FlutterCreditCardPlugin()
      if #available(iOS 13.0, *) {
          let factory = FLNativeViewFactory(messenger: registrar.messenger())
          registrar.register(factory, withId: "CreditCardScannerView")
      } else {
          // Fallback on earlier versions
      }
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let args = call.arguments as? Dictionary<String, Any>
      switch call.method {
      case Constants.checkPermission:
          print("asda")
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
