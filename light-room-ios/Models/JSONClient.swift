import Foundation
import LlamaKit
import Argo

class JSONClient {
  let client = NetworkClient()

  func performRequest(request: NSURLRequest, callback: Result<JSONValue> -> ()) {
    client.performRequest(request) { callback(JSONValue.parse <^> $0 >>- dataToJSON) }
  }
}

private func dataToJSON(data: NSData) -> Result<AnyObject> {
  var error: NSError?
  let obj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)

  if let err = error {
    return failure(err)
  }

  return success(obj ?? [:])
}
