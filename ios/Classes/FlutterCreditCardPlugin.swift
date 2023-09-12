import Flutter
import CoreMotion

public class FlutterCreditCardPlugin: NSObject, FlutterPlugin {
    private var gyroscopeChannel: GyroscopeChannelImpl?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FlutterCreditCardPlugin()
        instance.gyroscopeChannel = GyroscopeChannelImpl(messenger: registrar.messenger())
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        gyroscopeChannel = nil
    }
}
