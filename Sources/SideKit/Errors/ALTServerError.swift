//
//  ALTServerError.swift
//
//
//  Created by Joseph Mattiello on 2/24/23.
//

import Foundation

public let AltServerErrorDomain = "com.rileytestut.AltServer"

public let ALTUnderlyingErrorDomainErrorKey = "underlyingErrorDomain"
public let ALTUnderlyingErrorCodeErrorKey = "underlyingErrorCode"
public let ALTProvisioningProfileBundleIDErrorKey = "bundleIdentifier"
public let ALTAppNameErrorKey = "appName"
public let ALTDeviceNameErrorKey = "deviceName"

public enum ALTServerError: LocalizedError, Codable, RawRepresentable {
    public var rawValue: Int {
        switch self {
        case .underlyingError: return -1
        default: return errorCode
        }
    }

    public typealias RawValue = Int
    public typealias Code = ALTServerError

    case underlyingError(domain: String, code: Int)
    case unknown(code: Int = 0)
    case connectionFailed(underlyingError: Error? = nil)
    case lostConnection(underlyingError: Error? = nil)
    case deviceNotFound
    case deviceWriteFailed
    case invalidRequest(underlyingError: Error? = nil)
    case invalidResponse(underlyingError: Error? = nil)
    case invalidApp
    case installationFailed
    case maximumFreeAppLimitReached
    case unsupportediOSVersion
    case unknownRequest
    case unknownResponse
    case invalidAnisetteData
    case pluginNotFound
    case profileNotFound
    case appDeletionFailed
    case requestedAppNotRunning(appName: String = "Unknown", deviceName: String = "UnknownDevice")

    enum CodingKeys: String, CodingKey {
        case errorDomain
        case errorCode
        case rawValue
    }

    public static var errorDomain: String { "com.rileytestut.AltServer" }

    public var errorDomain: String {
        switch self {
        case let .underlyingError(domain, _):
            return domain
        default:
            return Self.errorDomain
        }
    }

    public var code: RawValue { errorCode }
    public var errorCode: RawValue {
        switch self {
        case let .underlyingError(_, code):
            return code
        case let .unknown(code):
            return code
        default:
            return ALTServerError.code(for: self)
        }
    }

    public static func code(for error: ALTServerError) -> RawValue {
        switch error {
        case .underlyingError:
            return -1
        case .connectionFailed:
            return 1
        case .lostConnection:
            return 2
        case .deviceNotFound:
            return 3
        case .deviceWriteFailed:
            return 4
        case .invalidRequest:
            return 5
        case .invalidResponse:
            return 6
        case .invalidApp:
            return 7
        case .installationFailed:
            return 8
        case .maximumFreeAppLimitReached:
            return 9
        case .unsupportediOSVersion:
            return 10
        case .unknownRequest:
            return 11
        case .unknownResponse:
            return 12
        case .invalidAnisetteData:
            return 13
        case .pluginNotFound:
            return 14
        case .profileNotFound:
            return 15
        case .appDeletionFailed:
            return 16
        case .requestedAppNotRunning:
            return 100
        case .unknown:
            return 0
        }
    }
}

public extension ALTServerError {
    init?(rawValue: Int) {
        switch rawValue {
        case -1:
            self = .underlyingError(domain: "", code: -1)
        case 0:
            self = .unknown()
        case 1:
            self = .connectionFailed(underlyingError: nil)
        case ALTServerError.lostConnection().errorCode:
            self = .lostConnection()
        case ALTServerError.deviceNotFound.errorCode:
            self = .deviceNotFound
        case ALTServerError.deviceWriteFailed.errorCode:
            self = .deviceWriteFailed
        case ALTServerError.invalidRequest().errorCode:
            self = .invalidRequest()
        case ALTServerError.invalidResponse().errorCode:
            self = .invalidResponse()
        case ALTServerError.invalidApp.errorCode:
            self = .invalidApp
        case ALTServerError.installationFailed.errorCode:
            self = .installationFailed
        case ALTServerError.maximumFreeAppLimitReached.errorCode:
            self = .maximumFreeAppLimitReached
        case ALTServerError.unsupportediOSVersion.errorCode:
            self = .unsupportediOSVersion
        case ALTServerError.unknownRequest.errorCode:
            self = .unknownRequest
        case ALTServerError.unknownResponse.errorCode:
            self = .unknownResponse
        case ALTServerError.invalidAnisetteData.errorCode:
            self = .invalidAnisetteData
        case ALTServerError.pluginNotFound.errorCode:
            self = .pluginNotFound
        case ALTServerError.profileNotFound.errorCode:
            self = .profileNotFound
        case ALTServerError.appDeletionFailed.errorCode:
            self = .appDeletionFailed
        case ALTServerError.requestedAppNotRunning().errorCode:
            self = .requestedAppNotRunning()
        default:
            return nil
        }
    }
}

// extension ALTServerError: CaseIterable {
//    public static var allCases: [ALTServerError] {
//        return [.underlyingError(domain: "", code: 0),
//                .unknown,
//                .connectionFailed,
//                .lostConnection,
//                .deviceNotFound,
//                .deviceWriteFailed,
//                .invalidRequest,
//                .invalidResponse,
//                .invalidApp,
//                .installationFailed,
//                .maximumFreeAppLimitReached,
//                .unsupportediOSVersion,
//                .unknownRequest,
//                .unknownResponse,
//                .invalidAnisetteData,
//                .pluginNotFound,
//                .profileNotFound,
//                .appDeletionFailed,
//                .requestedAppNotRunning,
//                .unknown(code: 0)]
//    }
// }

public extension ALTServerError {
    internal var userInfo: [String: Any] { (self as NSError).userInfo }

    private func profileErrorLocalizedDescription(baseDescription: String) -> String {
        let bundleID = userInfo[ALTProvisioningProfileBundleIDErrorKey] as? String ?? NSLocalizedString("this app", comment: "")
        let profileType = (bundleID == "com.apple.configurator.profile-install") ? NSLocalizedString("Configuration Profile", comment: "") : NSLocalizedString("Provisioning Profile", comment: "")
        let fullDescription = String(format: NSLocalizedString("%@ %@ is not valid.", comment: ""), profileType, bundleID)
        return [baseDescription, fullDescription].filter { !$0.isEmpty }.joined(separator: " ")
    }

    var errorDescription: String? {
        switch self {
        case let .underlyingError(domain, code):
            return String(format: NSLocalizedString("Underlying error (%@, %d)", comment: "ALTServerError"), domain, code)
        case .connectionFailed:
            return NSLocalizedString("Could not connect to AltServer.", comment: "")
        case .lostConnection:
            return NSLocalizedString("Lost connection to AltServer.", comment: "")
        case .deviceNotFound:
            return NSLocalizedString("AltServer could not find this device.", comment: "")
        case .deviceWriteFailed:
            return NSLocalizedString("Failed to write app data to device.", comment: "")
        case .invalidRequest:
            return NSLocalizedString("AltServer received an invalid request.", comment: "")
        case .invalidResponse:
            return NSLocalizedString("AltServer sent an invalid response.", comment: "")
        case .invalidApp:
            return NSLocalizedString("The app is invalid.", comment: "")
        case .installationFailed:
            return NSLocalizedString("An error occurred while installing the app.", comment: "")
        case .maximumFreeAppLimitReached:
            return NSLocalizedString("Cannot activate more than 3 apps and app extensions.", comment: "")
        case .unsupportediOSVersion:
            return NSLocalizedString("Your device must be running iOS 12.2 or later to install AltStore.", comment: "")
        case .unknownRequest:
            return NSLocalizedString("AltServer does not support this request.", comment: "")
        case .unknownResponse:
            return NSLocalizedString("Received an unknown response from AltServer.", comment: "")
        case .invalidAnisetteData:
            return NSLocalizedString("The provided Anisette data is invalid.", comment: "")
        case .pluginNotFound:
            return NSLocalizedString("AltServer could not connect to Mail plug-in.", comment: "")
        case .profileNotFound:
            return NSLocalizedString("Could not find profile.", comment: "")
        case .appDeletionFailed:
            return NSLocalizedString("An error occurred while removing the app.", comment: "")
        case let .requestedAppNotRunning(appName, deviceName):
            return String(format: NSLocalizedString("The requested app %@ is not currently running on device %@.", comment: ""), appName, deviceName)
        case let .unknown(code):
            return String(format: NSLocalizedString("An unknown error occurred with code %d.", comment: ""), code)
        }
    }
}

public extension ALTServerError {
    var failureReason: String? {
        switch self {
        case let .underlyingError(domain, code):
            let underlyingError = NSError(domain: domain, code: code, userInfo: nil)
            if let localizedFailureReason = underlyingError.localizedFailureReason {
                return localizedFailureReason
            } else if let underlyingErrorCode = underlyingError.userInfo[ALTUnderlyingErrorCodeErrorKey] as? String {
                return String(format: NSLocalizedString("Error code: %@", comment: ""), underlyingErrorCode)
            }
            return nil

        case .unknown:
            return NSLocalizedString("An unknown error occured.", comment: "Unknown ALTServerError")

        case .connectionFailed:
            #if TARGET_OS_OSX
                return NSLocalizedString("There was an error connecting to the device.", comment: "Failed to connect ALTServerError")
            #else
                return NSLocalizedString("Could not connect to AltServer.", comment: "Could not connect ALTServerError")
            #endif

        case .lostConnection:
            return NSLocalizedString("Lost connection to AltServer.", comment: "Lost connection ALTServerError")

        case .deviceNotFound:
            return NSLocalizedString("AltServer could not find this device.", comment: "Device not found ALTServerError")

        case .deviceWriteFailed:
            return NSLocalizedString("Failed to write app data to device.", comment: "Failed to write data ALTServerError")

        case .invalidRequest:
            return NSLocalizedString("AltServer received an invalid request.", comment: "Invalid request ALTServerError")

        case .invalidResponse:
            return NSLocalizedString("AltServer sent an invalid response.", comment: "Invalid response ALTServerError")

        case .invalidApp:
            return NSLocalizedString("The app is invalid.", comment: "Invalid app ALTServerError")

        case .installationFailed:
            return NSLocalizedString("An error occured while installing the app.", comment: "Installation failed ALTServerError")

        case .maximumFreeAppLimitReached:
            return NSLocalizedString("Cannot activate more than 3 apps and app extensions.", comment: "Maximum app limit reached ALTServerError")

        case .unsupportediOSVersion:
            return NSLocalizedString("Your device must be running iOS 12.2 or later to install AltStore.", comment: "Unsupported iOS version ALTServerError")

        case .unknownRequest:
            return NSLocalizedString("AltServer does not support this request.", comment: "Unknown request ALTServerError")

        case .unknownResponse:
            return NSLocalizedString("Received an unknown response from AltServer.", comment: "Unknown response ALTServerError")

        case .invalidAnisetteData:
            return NSLocalizedString("The provided anisette data is invalid.", comment: "Invalid anisette data ALTServerError")

        case .pluginNotFound:
            return NSLocalizedString("AltServer could not connect to Mail plug-in.", comment: "Plugin not found ALTServerError")

        case .profileNotFound:
            return profileErrorLocalizedDescription(baseDescription: NSLocalizedString("Could not find profile", comment: ""))

        case .appDeletionFailed:
            return NSLocalizedString("An error occured while removing the app.", comment: "App deletion failed ALTServerError")

        case let .requestedAppNotRunning(appName, deviceName):
            return String(format: NSLocalizedString("%@ is not currently running on %@.", comment: "Requested app not running ALTServerError"), appName, deviceName)
        }
    }
}

public extension ALTServerError {
    var recoverySuggestion: String? {
        switch self {
        case .connectionFailed, .deviceNotFound:
            return NSLocalizedString("Make sure you have trusted this device with your computer and WiFi sync is enabled.", comment: "ALTServerError recovery suggestion")
        case .pluginNotFound:
            return NSLocalizedString("Make sure Mail is running and the plug-in is enabled in Mail's preferences.", comment: "ALTServerError recovery suggestion")
        case .maximumFreeAppLimitReached:
            return NSLocalizedString("Make sure “Offload Unused Apps” is disabled in Settings > iTunes & App Stores, then install or delete all offloaded apps.", comment: "ALTServerError recovery suggestion")
        case .requestedAppNotRunning:
            let deviceName = userInfo[ALTDeviceNameErrorKey] as? String ?? NSLocalizedString("your device", comment: "ALTServerError recovery suggestion")
            return String(format: NSLocalizedString("Make sure the app is running in the foreground on %@ then try again.", comment: "ALTServerError recovery suggestion"), deviceName)
        default:
            return nil
        }
    }
}

public extension NSError {
    convenience init(altServerError code: ALTServerError, userInfo: [String: Any]? = nil) {
        self.init(domain: AltServerErrorDomain, code: code.errorCode, userInfo: userInfo)
    }
}
