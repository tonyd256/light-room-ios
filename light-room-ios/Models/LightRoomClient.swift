import Foundation

class LightRoomClient {
  private let manager = DiscoveryManager()
  private let requestQueue = NSOperationQueue()
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
    let request: NSURLRequest? = host.map { NSURL(string: "\($0)\textures").map { NSURLRequest(URL: $0) } } ?? .None

    let task = request.map { NSURLSession.sharedSession().dataTaskWithRequest($0) { data, response, error in
      let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
      

    } }
    task?.resume()
  }

  func getTexture(name: String, callback: NSData -> ()) {

  }

  func playTexture(name: String, callback: () -> ()) {

  }
}

extension LightRoomClient {
  func setWhiteLevel(level: Double, callback: () -> ()) {

  }
}
