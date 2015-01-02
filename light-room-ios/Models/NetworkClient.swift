import Foundation
import LlamaKit

class NetworkClient {
  func performRequest(request: NSURLRequest, callback: Result<NSData> -> ()) {
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
      if let err = error {
        callback(failure(err))
      } else {
        callback(parseResponse(data, response))
      }
    }
    task.resume()
  }
}

private func parseResponse(data: NSData?, response: NSURLResponse?) -> Result<NSData> {
  var status = 500
  if let res = response as? NSHTTPURLResponse {
    status = res.statusCode
  }

  if contains(200..<300, status) {
    return success(data ?? NSData())
  } else {
    return failure(networkError(data, status))
  }
}

private func networkError(data: NSData?, status: Int) -> NSError {
  var userInfo: NSDictionary? = .None
  if let d = data {
    userInfo = ["data": d]
  }
  return NSError(domain: "NetworkClientError", code: status, userInfo: userInfo)
}
