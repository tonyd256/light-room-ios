import Foundation

private let LightRoomServerHostName = "light-room.local."

class DiscoveryManager: NSObject, NSNetServiceBrowserDelegate, NSNetServiceDelegate {
  let browser = NSNetServiceBrowser()
  var services: [NSNetService] = []
  var found: (String -> ())?

  func startBrowsing(found: String -> ()) {
    self.found = found
    browser.delegate = self
    browser.searchForServicesOfType("_afpovertcp._tcp", inDomain: "local")
  }

  func stopBrowsing() {
    browser.stop()
    services = []
    found = .None
  }

  func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {
    services += [aNetService]
    aNetService.delegate = self
    aNetService.resolveWithTimeout(30)
  }

  func netServiceDidResolveAddress(sender: NSNetService) {
    if sender.hostName == .Some(LightRoomServerHostName) {
      if let datas = sender.addresses as? [NSData] {
        let addrs: [sockaddr_in] = datas.map { a in
          var ad = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
          a.getBytes(&ad, length: sizeof(sockaddr_in))
          return ad
        }

        let addres = filter(addrs) { a in
          return a.sin_addr.s_addr & 255 == 192
        }

        if let a = addres.first {
          let a1 = (a.sin_addr.s_addr >> 24) & 255
          let a2 = (a.sin_addr.s_addr >> 16) & 255
          let a3 = (a.sin_addr.s_addr >> 8) & 255
          found?("192.\(a3).\(a2).\(a1)")
        }
      }
    }
  }
}
