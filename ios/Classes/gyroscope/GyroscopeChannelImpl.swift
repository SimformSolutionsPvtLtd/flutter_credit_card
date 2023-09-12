import Flutter
import CoreMotion

internal class GyroscopeChannelImpl {
    private var motionManager: CMMotionManager?
    private var eventChannel: FlutterEventChannel?
    private var methodChannel: FlutterMethodChannel?
    private var streamHandler: GyroscopeStreamHandler?

    init(messenger: FlutterBinaryMessenger) {
        eventChannel = FlutterEventChannel(name: Constants.gyroEventChannel, binaryMessenger: messenger)
        methodChannel = FlutterMethodChannel(name: Constants.gyroMethodChannel, binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler(onMethodCall)
    }
    
    deinit {
        eventStreamDisposal()
        methodChannel?.setMethodCallHandler(nil)
        methodChannel = nil
    }
    
    private func onMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case Constants.initiateEvents:
            eventStreamSetup()
            result(nil)
        case Constants.isGyroAvailable:
            result(hasGyroAvailability())
        case Constants.cancelEvents:
            eventStreamDisposal()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func eventStreamSetup() {
        motionManager = CMMotionManager()
        if (!hasGyroAvailability()) {
            motionManager = nil
            return
        }

        streamHandler = streamHandler ?? GyroscopeStreamHandler(motionManager: motionManager!)
        eventChannel?.setStreamHandler(streamHandler)
    }
    
    private func eventStreamDisposal() {
        _ = streamHandler?.onCancel(withArguments: nil)
        eventChannel?.setStreamHandler(nil)
        streamHandler = nil
        motionManager = nil
    }
    
    private func hasGyroAvailability() -> Bool {
        return motionManager?.isGyroAvailable ?? false
    }
}
