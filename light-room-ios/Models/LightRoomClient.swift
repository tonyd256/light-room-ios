import Foundation
import UIKit.UIImage
import Argo

class LightRoomClient {
  private let manager = DiscoveryManager()
  private let requestQueue = NSOperationQueue()
  private let client = JSONClient()
  private var host: String?

  class var sharedClient: LightRoomClient {
    struct Static {
      static let instance = LightRoomClient()
    }
    return Static.instance
  }

  private init() {
    manager.startBrowsing(setHost)
    requestQueue.maxConcurrentOperationCount = 1
    requestQueue.qualityOfService = .UserInitiated
    requestQueue.name = "LightRoomClientQueue"
  }

  func setHost(host: String) {
    self.host = host
  }
}

extension LightRoomClient {
  func getTextures(callback: [String] -> ()) {
    let request: NSURLRequest? = host.map { NSURL(string: "\($0)/textures").map { NSURLRequest(URL: $0) } } ?? .None
    request.map { self.client.performRequest($0) { r in onMain { callback(r.value() >>- { $0.json >>- JSONValue.map } ?? []) } } }
  }

  func getTexture(name: String, callback: UIImage -> ()) {
    let client = NetworkClient()
    let request: NSURLRequest? = host.map { NSURL(string: "\($0)/images/\(name).jpeg").map { NSURLRequest(URL: $0) } } ?? .None
    request.map { client.performRequest($0) { r in onMain { callback(r.value() >>- { $0.data >>- {UIImage(data: $0)} } ?? UIImage()) } } }
  }

  func playTexture(name: String, callback: () -> ()) {
    let client = NetworkClient()
    let request: NSMutableURLRequest? = host.map { NSURL(string: "\($0)/commands").map { NSMutableURLRequest(URL: $0) } } ?? .None
    let json = ["command": "texture", "name": name]
    let data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(0), error: nil)
    request?.HTTPBody = data
    request?.HTTPMethod = "POST"
    request.map { client.performRequest($0) { _ in onMain(callback) } }
  }
}

extension LightRoomClient {
  func setWhiteLevel(level: Double, callback: () -> ()) {
    let client = NetworkClient()
    let request: NSMutableURLRequest? = host.map { NSURL(string: "\($0)/commands").map { NSMutableURLRequest(URL: $0) } } ?? .None
    let json = ["command": "white", "level": level]
    let data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(0), error: nil)
    request?.HTTPBody = data
    request?.HTTPMethod = "POST"
    request.map { client.performRequest($0) { _ in onMain(callback) } }
  }
}

private func onMain(f: () -> ()) {
  dispatch_async(dispatch_get_main_queue(), f)
}
