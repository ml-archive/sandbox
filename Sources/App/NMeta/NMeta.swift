import Vapor
import Foundation
final class NMeta {
    
    static var instance: NMeta?
    
    let platform: String
    let environment: String
    let version: String
    let major: Int
    let minor: Int
    let patch: Int
    let deviceOs: String
    let device: String
    
    static func setInstance(nMeta: String) throws {
        try self.instance = NMeta(nMeta: nMeta)
    }
    
    
    static func getInstance() throws -> NMeta {
    
        guard let unwrappedInstance: NMeta = instance else {
          throw Abort.custom(status: .badRequest, message: "Missing N-Meta header")
        }
        
        return unwrappedInstance
    }
    
    init(nMeta: String) throws {
        let nMetaArr = nMeta.components(separatedBy: ";")

        
        // Set platform
        if(nMetaArr.count < 1 || !NMeta.platforms().contains(nMetaArr[0])) {
            throw Abort.custom(status: .badRequest, message: "Platform is not supported")
        }
        
        self.platform = nMetaArr[0];
        
        // Set environment
        if(nMetaArr.count < 2 || !NMeta.environments().contains(nMetaArr[1])) {
            throw Abort.custom(status: .badRequest, message: "Environment is not supported")
        }
        
        self.environment = nMetaArr[1];
        
        // Since web is normally using a valid User-Agent there is no reason for asking for more
        if(platform == "web") {
            self.version = "0.0.0"
            self.major = 0
            self.minor = 0
            self.patch = 0
            self.deviceOs = "N/A"
            self.device = "N/A"
            return;
        }
        
        // Set version
        if(nMetaArr.count < 3) {
            throw Abort.custom(status: .badRequest, message: "Missing version")
        }
        
        self.version = nMetaArr[2]
        
        // Set major, minor & patch
        let versionArr = version.components(separatedBy: ".")
        
        self.major = versionArr.count >= 1 ? Int(versionArr[0]) ?? 0 : 0
        self.minor = versionArr.count >= 2 ? Int(versionArr[1]) ?? 0 : 0
        self.patch = versionArr.count >= 3 ? Int(versionArr[2]) ?? 0 : 0
       
        // Set device os
        if(nMetaArr.count < 4) {
            throw Abort.custom(status: .badRequest, message: "Missing device os")
        }
        
        self.deviceOs = nMetaArr[3]
        
        // Set device
        if(nMetaArr.count < 5) {
            throw Abort.custom(status: .badRequest, message: "Missing device")
        }
        
        self.device = nMetaArr[4]
    }
    
    // TODO CONFIG
    static func platforms() -> [String] {
        return [
            "web",
            "android",
            "ios",
            "windows"
        ]
    }
    
    // TODO CONFIG
    static func environments() -> [String] {
        return [
            "local",
            "development",
            "staging",
            "production"
        ]
    }
    
    func toNode() -> Node {
        return Node([
            "platform": Node(platform),
            "environment": Node(environment),
            "version": Node(version),
            "major": Node(major),
            "minor": Node(minor),
            "patch": Node(patch),
            "deviceOs": Node(deviceOs),
            "device": Node(device)
        ])
    }
}
