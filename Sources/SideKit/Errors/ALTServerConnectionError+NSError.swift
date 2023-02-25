//
//  ALTServerConnectionError+NSError.swift
//
//
//  Created by Joseph Mattiello on 2/24/23.
//

import Foundation

#if false
    public extension ALTServerConnectionError {
        static func setUserInfoProvider(name: String, device: String, bundleId: String = Bundle.main.bundleIdentifier!) {
            // Set the user info value provider for the AltServerErrorDomain
            NSError.setUserInfoValueProvider(forDomain: AltServerErrorConnectionDomain) { error, key in
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
#endif
