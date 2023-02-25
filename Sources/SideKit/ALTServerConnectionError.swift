//
//  ALTServerConnectionError.swift
//  
//
//  Created by Joseph Mattiello on 2/24/23.
//

import Foundation

public enum ALTServerConnectionError: Int, LocalizedError {
    case unknown
    case deviceLocked
    case invalidRequest
    case invalidResponse
    case usbmuxd
    case ssl
    case timedOut

    public static var errorDomain: String { return "com.rileytestut.AltServer.Connection" }
}

public extension ALTServerConnectionError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown connection error", comment: "ALTServerConnectionError")
        case .deviceLocked:
            return NSLocalizedString("Device locked", comment: "ALTServerConnectionError")
        case .invalidRequest:
            return NSLocalizedString("Invalid request", comment: "ALTServerConnectionError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "ALTServerConnectionError")
        case .usbmuxd:
            return NSLocalizedString("USBMuxd error", comment: "ALTServerConnectionError")
        case .ssl:
            return NSLocalizedString("SSL error", comment: "ALTServerConnectionError")
        case .timedOut:
            return NSLocalizedString("Timed out", comment: "ALTServerConnectionError")
        }
    }
}

public extension ALTServerConnectionError {
    var recoverySuggestion: String? {
        switch self {
        case .deviceLocked:
            return NSLocalizedString("Unlock your device and try again.", comment: "ALTServerConnectionError recovery suggestion")
        case .invalidRequest:
            return NSLocalizedString("Make sure AltServer is running and try again.", comment: "ALTServerConnectionError recovery suggestion")
        case .invalidResponse:
            return NSLocalizedString("Make sure AltServer is running and try again.", comment: "ALTServerConnectionError recovery suggestion")
        case .usbmuxd:
            return NSLocalizedString("Make sure iTunes is not running, and no other software is using the device over USB.", comment: "ALTServerConnectionError recovery suggestion")
        case .ssl:
            return NSLocalizedString("Make sure your computer's time and date are correct, and try again.", comment: "ALTServerConnectionError recovery suggestion")
        case .timedOut:
            return NSLocalizedString("Make sure your device is unlocked and try again.", comment: "ALTServerConnectionError recovery suggestion")
        default:
            return nil
        }
    }
}

public extension ALTServerConnectionError {
    var failureReason: String? {
        switch self {
        case .deviceLocked:
            return NSLocalizedString("Your device is locked. Unlock your device and try again.", comment: "ALTServerConnectionError failure reason")
        case .invalidRequest:
            return NSLocalizedString("The request sent to AltServer is invalid.", comment: "ALTServerConnectionError failure reason")
        case .invalidResponse:
            return NSLocalizedString("The response from AltServer is invalid.", comment: "ALTServerConnectionError failure reason")
        case .usbmuxd:
            return NSLocalizedString("AltServer cannot communicate with your device over USB. Make sure iTunes is not running, and no other software is using the device over USB.", comment: "ALTServerConnectionError failure reason")
        case .ssl:
            return NSLocalizedString("There is a problem with the SSL connection to AltServer. Make sure your computer's time and date are correct, and try again.", comment: "ALTServerConnectionError failure reason")
        case .timedOut:
            return NSLocalizedString("The connection to AltServer timed out. Make sure your device is unlocked and try again.", comment: "ALTServerConnectionError failure reason")
        case .unknown:
            return NSLocalizedString("An unknown error occurred with AltServer.", comment: "ALTServerConnectionError failure reason")
        }
    }
}

public extension ALTServerConnectionError {
    var code: Int {
        return self.rawValue
    }
}


extension ALTServerConnectionError: Codable {
    enum CodingKeys: String, CodingKey {
        case deviceLocked
        case invalidRequest
        case invalidResponse
        case usbmuxd
        case ssl
        case timedOut
        case unknown
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let _ = try? values.decode(Bool.self, forKey: .deviceLocked) {
            self = .deviceLocked
            return
        }
        if let _ = try? values.decode(Bool.self, forKey: .invalidRequest) {
            self = .invalidRequest
            return
        }
        if let _ = try? values.decode(Bool.self, forKey: .invalidResponse) {
            self = .invalidResponse
            return
        }
        if let _ = try? values.decode(Bool.self, forKey: .usbmuxd) {
            self = .usbmuxd
            return
        }
        if let _ = try? values.decode(Bool.self, forKey: .ssl) {
            self = .ssl
            return
        }
        if let _ = try? values.decode(Bool.self, forKey: .timedOut) {
            self = .timedOut
            return
        }

        self = .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .deviceLocked:
            try container.encode(true, forKey: .deviceLocked)
        case .invalidRequest:
            try container.encode(true, forKey: .invalidRequest)
        case .invalidResponse:
            try container.encode(true, forKey: .invalidResponse)
        case .usbmuxd:
            try container.encode(true, forKey: .usbmuxd)
        case .ssl:
            try container.encode(true, forKey: .ssl)
        case .timedOut:
            try container.encode(true, forKey: .timedOut)
        case .unknown:
            break
        }
    }
}
