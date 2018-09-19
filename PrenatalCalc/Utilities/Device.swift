//
//  Device.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 8/26/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import Foundation
import UIKit

let thisDevice = Device()
struct Device {
    // MARK: - Singletons
    static var TheCurrentDevice: UIDevice {
        struct Singleton {
            static let device = UIDevice.current
        }
        return Singleton.device
    }
    
    static var TheCurrentDeviceVersion: Float {
        struct Singleton {
            static let version = Float(UIDevice.current.systemVersion)!
        }
        return Singleton.version
    }
    
    var height: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
    
    var width: CGFloat {
        struct Singleton {
            static let width = UIScreen.main.bounds.size.width
        }
        return Singleton.width
    }

    
    // MARK: - Device Idiom Checks
    var deviceType: String {
        if self.isPhone() {
            return "iPhone"
        } else if isPad() {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }
    
    static var debugOrRelease: String {
        #if DEBUG
        return "Debug"
        #else
        return "Release"
        #endif
    }
    
    var simulatorOrDevice: String {
        #if targetEnvironment(simulator)
        return "Simulator"
        #else
        return "Device"
        #endif
    }
    
    func isPhone() -> Bool {
        return Device.TheCurrentDevice.userInterfaceIdiom == .phone
    }
    
    func isPad() -> Bool {
        return Device.TheCurrentDevice.userInterfaceIdiom == .pad
    }
    
    static func isDebug() -> Bool {
        return debugOrRelease == "Debug"
    }
    
    static func isRelease() -> Bool {
        return debugOrRelease == "Release"
    }
    
    func isSimulator() -> Bool {
        return simulatorOrDevice == "Simulator"
    }
    
    func isDevice() -> Bool {
        return simulatorOrDevice == "Device"
    }
}
