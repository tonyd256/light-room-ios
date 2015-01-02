import Foundation
import LlamaKit
import Argo

class JSONClient {
  let client = NetworkClient()

  func performRequest(request: NSURLRequest, callback: Result<JSONResponse> -> ()) {
    client.performRequest(request) { result in
      switch result {
      case let .Failure(error): callback(failure(error))
      case let .Success(response): callback(success(JSONResponse(response: response.unbox)))
      }
    }
  }
}

struct JSONResponse {
  let json: JSONValue?
  let status: Int = 500

  init(response: NetworkResponse) {
    status = response.status
    json = response.data >>- dataToJSON >>- JSONValue.parse
  }
}

private func dataToJSON(data: NSData) -> AnyObject? {
  return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
}
