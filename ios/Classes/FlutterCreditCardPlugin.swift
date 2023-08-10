import Flutter
import UIKit
import CoreMotion

private var motionManager: CMMotionManager?
private var eventChannels = [String: FlutterEventChannel]()
private var streamHandlers = [String: FlutterStreamHandler]()
private func initMotionManager() {
    if motionManager == nil {
        motionManager = CMMotionManager()
    }
}

private func isGyroscopeAvailable() -> Bool {
        initMotionManager()
        let gyroAvailable = motionManager?.isGyroAvailable ?? false
        return gyroAvailable
}


public class FlutterCreditCardPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let gyroscopeStreamHandlerName = "com.simform.flutter_credit_card/gyroscope"
        let gyroscopeStreamHandler = MTGyroscopeStreamHandler()
        streamHandlers[gyroscopeStreamHandlerName] = gyroscopeStreamHandler
        
        let gyroscopeChannel = FlutterEventChannel(name: gyroscopeStreamHandlerName, binaryMessenger: registrar.messenger())
        gyroscopeChannel.setStreamHandler(gyroscopeStreamHandler)
        eventChannels[gyroscopeStreamHandlerName] = gyroscopeChannel
        
        
        let channel = FlutterMethodChannel(name: "com.simform.flutter_credit_card", binaryMessenger: registrar.messenger())
        let instance = FlutterCreditCardPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isGyroscopeAvailable":
            let avaialble = isGyroscopeAvailable()
            result(avaialble)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

public class MTGyroscopeStreamHandler: NSObject, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        initMotionManager()
        motionManager?.startGyroUpdates(to: OperationQueue()){ (gyroData, error) in
            if let rotationRate = gyroData?.rotationRate {
                sink([rotationRate.x,rotationRate.y,rotationRate.z])
            }
        }
        
        return nil
    }
    // Add the timer to the current run loop.
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager?.stopGyroUpdates()
        return FlutterError()
    }
    
}

