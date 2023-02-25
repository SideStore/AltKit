//
//  Server.swift
//  AltStore
//
//  Created by Riley Testut on 6/20/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

import Foundation

@objc(ALTServer)
public class Server: NSObject, Identifiable {
    public let id: String
    public let service: NetService

    public var name: String? {
        return service.hostName
    }

    public internal(set) var isPreferred = false

    override public var hash: Int {
        return id.hashValue ^ service.name.hashValue
    }

    init?(service: NetService, txtData: Data) {
        let txtDictionary = NetService.dictionary(fromTXTRecord: txtData)
        guard let identifierData = txtDictionary["serverID"], let identifier = String(data: identifierData, encoding: .utf8) else { return nil }

        id = identifier
        self.service = service

        super.init()
    }

    override public func isEqual(_ object: Any?) -> Bool {
        guard let server = object as? Server else { return false }

        return id == server.id && service.name == server.service.name // service.name is consistent, and is not the human readable name (hostName).
    }
}
