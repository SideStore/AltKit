//
//  ALTServerError+Conveniences.swift
//  AltKit
//
//  Created by Riley Testut on 6/4/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import Foundation

public extension ALTServerError {
    init<E: Error>(_ error: E) {
        switch error {
        case let error as ALTServerError: self = error
        case let error as ALTServerConnectionError:
            self = .connectionFailed(underlyingError: error)
        case is DecodingError: self = .invalidRequest(underlyingError: error)
        case let error as NSError:
            var userInfo = error.userInfo
            if !userInfo.keys.contains(NSUnderlyingErrorKey) {
                // Assign underlying error (if there isn't already one).
                userInfo[NSUnderlyingErrorKey] = error
            }

            self = .underlyingError(domain: error.domain, code: error.code)
        }
    }

    init<E: Error>(_ code: ALTServerError, underlyingError: E) {
        switch code {
        case .connectionFailed: self = .connectionFailed(underlyingError: underlyingError)
        case .lostConnection: self = .lostConnection(underlyingError: underlyingError)
        case .invalidRequest: self = .invalidRequest(underlyingError: underlyingError)
        case .invalidResponse: self = .invalidResponse(underlyingError: underlyingError)
        default: self = code
        }
    }
}
