import Foundation
import UIKit.UIImage
import Argo
import LlamaKit

class LightRoomClient {
  private let requestQueue = NSOperationQueue()
  private let jsonClient = JSONClient()
  private let networkClient = NetworkClient()
  private var requestFactory: RequestFactory?

  class var sharedClient: LightRoomClient {
    struct Static {
      static let instance = LightRoomClient()
    }
    return Static.instance
  }

  var isConnected: Bool {
    if let _ = requestFactory {
      return true
    } else {
      return false
    }
  }

  private init() {
    requestQueue.maxConcurrentOperationCount = 1
    requestQueue.qualityOfService = .UserInitiated
    requestQueue.name = "LightRoomClientQueue"
  }

  func setHost(host: String) {
    NSURL(string: "\(host):3000").map {
      self.requestFactory = RequestFactory(host: $0)
    }
  }
}

extension LightRoomClient {
  func getTextures(callback: Result<[String]> -> ()) {
    requestQueue.addOperationWithBlock { [unowned self] in
      _ = curry(self.jsonClient.performRequest) <^> self.requestFactory?.listTexturesRequest() <*> {
        onMain(callback, $0 >>- { toResult(JSONValue.map($0)) })
      }
    }
  }

  func getTexture(name: String, callback: Result<UIImage> -> ()) {
    requestQueue.addOperationWithBlock { [unowned self] in
      _ = curry(self.networkClient.performRequest) <^> self.requestFactory?.fetchTextureRequest(name) <*> {
        onMain(callback, $0 >>- { toResult(UIImage(data: $0)) })
      }
    }
  }

  func playTexture(name: String, callback: () -> ()) {
    let json = ["command": "texture", "name": name]
    requestQueue.addOperationWithBlock { [unowned self] in
      _ = curry(self.jsonClient.performRequest) <^> self.requestFactory?.postCommandRequest(json) <*> { _ in
        onMain(callback, ())
      }
    }
  }
}

extension LightRoomClient {
  func setWhiteLevel(level: Int, callback: () -> ()) {
    let json: [String: AnyObject] = ["command": "white", "level": level]
    requestQueue.addOperationWithBlock { [unowned self] in
      _ = curry(self.jsonClient.performRequest) <^> self.requestFactory?.postCommandRequest(json) <*> { _ in
        onMain(callback, ())
      }
    }
  }
}

private func onMain<T>(f: T -> (), t: T) {
  dispatch_async(dispatch_get_main_queue()) { f(t) }
}
