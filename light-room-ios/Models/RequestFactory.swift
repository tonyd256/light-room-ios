import Foundation

class RequestFactory {
  let host: NSURL

  init(host: NSURL) {
    self.host = host
  }

  func listTexturesRequest() -> NSURLRequest? {
    return NSURL(string: "textures", relativeToURL: host).map { NSURLRequest(URL: $0) } ?? .None
  }

  func fetchTextureRequest(name: String) -> NSURLRequest? {
    return NSURL(string: "images/\(name)?dim=200x200", relativeToURL: host).map { NSURLRequest(URL: $0) } ?? .None
  }

  func postCommandRequest(json: NSDictionary) -> NSURLRequest? {
    let request = NSURL(string: "commands", relativeToURL: host).map { NSMutableURLRequest(URL: $0) }  ?? .None
    let data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(0), error: nil)
    request?.HTTPBody = data
    request?.HTTPMethod = "POST"
    request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }
}
