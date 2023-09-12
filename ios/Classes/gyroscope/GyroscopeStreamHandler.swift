import Flutter
import UIKit
import CoreMotion

internal class GyroscopeStreamHandler: NSObject, FlutterStreamHandler {
    private var motionManager: CMMotionManager?

    init(motionManager: CMMotionManager) {
        self.motionManager = motionManager
        // Gyroscope event interval set to 60 fps, specified in seconds.
        self.motionManager!.gyroUpdateInterval = 0.016666
        super.init()
    }

    public func onListen(withArguments arguments: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
        motionManager?.startGyroUpdates(to: OperationQueue()){ (gyroData, error) in
            if let rotationRate = gyroData?.rotationRate {
                sink(GyroscopeStreamHandler.processForOrientation(rotationRate))
            }
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        motionManager?.stopGyroUpdates()
        motionManager = nil
        return nil
    }
    
    static private func processForOrientation(_ rotation: CMRotationRate) -> [Double] {
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.landscapeLeft:
            return [-rotation.y, rotation.x, rotation.z]
        case UIDeviceOrientation.landscapeRight:
            return [rotation.y, -rotation.x, rotation.z]
        default:
            return [rotation.x, rotation.y, rotation.z]
        }
    }
}
