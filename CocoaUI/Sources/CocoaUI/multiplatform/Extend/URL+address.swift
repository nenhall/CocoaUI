//
//  IPAddress.swift
//  AirBrush_Studio
//
//  Created by meitu@nenhall on 2022/9/14.
//

import Foundation

// https://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address : String?

    // Get list of all interfaces on the local machine:
    var ifaddrPtr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddrPtr) == 0 {
        // For each interface ...
        var ptr = ifaddrPtr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            guard let interface = ptr?.pointee else { continue }

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr?.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddrPtr)
    }
    return address
}
