import Foundation
import LlamaKit

class NetworkClient {
  func performRequest(request: NSURLRequest, callback: Result<NetworkResponse> -> ()) {
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      if let err = error {
        callback(failure(err))
      }
      callback(success(NetworkResponse(data: data, response: response)))
    }

    task.resume()
  }
}

struct NetworkResponse {
  let data: NSData?
  let status: Int = 500

  init(data: NSData?, response: NSURLResponse) {
    self.data = data
    if let res = response as? NSHTTPURLResponse {
      status = res.statusCode
    }
  }
}
