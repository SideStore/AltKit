//
//  ALTServerError+Conveniences.swift
//  AltKit
//
//  Created by Riley Testut on 6/4/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import Foundation

public extension ALTServerError
{
    init<E: Error>(_ error: E)
    {
        switch error
        {
        case let error as ALTServerError: self = error
        case let error as ALTServerConnectionError:
            self = .connectionFailed(underlyingError: error)
        case is DecodingError: self = .invalidRequest(underlyingError: error)
        case let error as NSError:
            var userInfo = error.userInfo
            if !userInfo.keys.contains(NSUnderlyingErrorKey)
            {
                // Assign underlying error (if there isn't already one).
                userInfo[NSUnderlyingErrorKey] = error
            }
            
            self = .underlyingError(domain: error.domain, code: error.code)
        }
    }
    
//    init<E: Error>(_ code: ALTServerError.Code, underlyingError: E)
//    {
//        self = ALTServerError(code, underlyingError: underlyingError)
//    }
}

public extension ALTServerError {
    static func setUserInfoProvider(name: String, device: String, bundleId: String = Bundle.main.bundleIdentifier!) {
        // Set the user info value provider for the AltServerErrorDomain
        NSError.setUserInfoValueProvider(forDomain: AltServerErrorDomain) { error, key in
            switch key {
            case ALTUnderlyingErrorDomainErrorKey:
                let error = error as NSError
                return (error.userInfo[NSUnderlyingErrorKey] as? NSError)?.domain
            case ALTUnderlyingErrorCodeErrorKey:
                let error = error as NSError
                return (error.userInfo[NSUnderlyingErrorKey] as? NSError)?.code
            case ALTProvisioningProfileBundleIDErrorKey:
                return bundleId
            case ALTAppNameErrorKey:
                return device
            case ALTDeviceNameErrorKey:
                return name
            default:
                return nil
            }
        }
    }
}
