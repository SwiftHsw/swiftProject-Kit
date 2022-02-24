//
//  UIDevice+Extend.swift
//  Gregarious
//
//  Created by csp on 2021/3/30.
//

import UIKit


extension UIDevice {
    
    /// 返回系统版本，如8.1
    static var sp_systemVersion: Float {
        return (self.current.systemVersion as NSString).floatValue
    }
    
    /// 返回系统版本(将小数点替换成0)，如120101
    static let sp_numberVersion: Int = {
        var versionString = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "0")
        if versionString.count < 5 { versionString.append("00") }
        return Int(versionString)!
    } ()
    
    /// 判断是否是iPad
    var sp_isPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    /// 判断是否是模拟器
    var sp_isSimulator: Bool {
        return TARGET_OS_SIMULATOR == 1
    }
    
    /// 判断是否能打电话
    var sp_canMakePhoneCalls: Bool {
        let can = UIApplication.shared.canOpenURL(URL(string: "tel://")!)
        return can
    }
    
    /// 返回设备的型号，如"iPhone6,1" "iPad4,6"
    var sp_machineModel: String {
        return SPDeviceModel.machineModel
    }
    
    /// 返回设备的型号名，如"iPhone 5s" "iPad mini 2"
    var sp_machineModelName: String? {
        return SPDeviceModel.allModels[self.sp_machineModel]
    }
    
    /// 返回模拟器设备的型号，如"iPhone 5s" "iPad mini 2"
    var sp_simulatorModelName: String? {
        guard let model = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] else { return nil }
        return SPDeviceModel.allModels[model]
    }
    
    /// 返回系统启动时间
    var sp_systemUptime: Date {
        return Date(timeIntervalSinceNow: (0 - ProcessInfo.processInfo.systemUptime))
    }
    
    /// 返回设备当前设置的语言，包含设备所在地，如'English (United States)'
    var sp_localeLanguage: String? {
        return NSLocale(localeIdentifier: Locale.current.identifier).displayName(forKey: .identifier, value: Locale.current.identifier)
    }
    
    /// 返回设置当前设置的语言的代号，如'en'
    var sp_localeLanguageCode: String? {
        return Locale.current.languageCode
    }
    
    /// 返回当前引导访问的状态，处于活动状态，返回true，否则返回false
    var sp_isGuidedAccessSessionActive: Bool {
        return UIAccessibility.isGuidedAccessEnabled
    }
    
    /// 返回当前电池的状态
    var sp_batteryState: UIDevice.BatteryState {
        var state = UIDevice.BatteryState.unknown
        let enabled = self.isBatteryMonitoringEnabled
        self.isBatteryMonitoringEnabled = false
        state = self.batteryState
        self.isBatteryMonitoringEnabled = enabled
        return state
    }
    
    /// 若用户启用低功耗模式，则返回true
    @available(iOS 9.0, *)
    var sp_lowPowerMode: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    
    private struct SPDeviceModel {
        static let machineModel: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let mirror = Mirror(reflecting: systemInfo.machine)
            
            let identifier = mirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        } ()
        
        // See https://www.theiphonewiki.com/wiki/Models
        static let allModels = ["Watch1,1" : "Apple Watch",
                                "Watch1,2" : "Apple Watch",
                                "Watch6,3" : "Apple Watch Series 6",
                                "Watch6,4" : "Apple Watch Series 6",
                                       
                                "iPod1,1" : "iPod touch 1",
                                "iPod2,1" : "iPod touch 2",
                                "iPod3,1" : "iPod touch 3",
                                "iPod4,1" : "iPod touch 4",
                                "iPod5,1" : "iPod touch 5",
                                "iPod7,1" : "iPod touch 6",
                                
                                "iPhone1,1" : "iPhone 1G",
                                "iPhone1,2" : "iPhone 3G",
                                "iPhone2,1" : "iPhone 3GS",
                                "iPhone3,1" : "iPhone 4 (GSM)",
                                "iPhone3,2" : "iPhone 4",
                                "iPhone3,3" : "iPhone 4 (CDMA)",
                                "iPhone4,1" : "iPhone 4S",
                                "iPhone5,1" : "iPhone 5",
                                "iPhone5,2" : "iPhone 5",
                                "iPhone5,3" : "iPhone 5c",
                                "iPhone5,4" : "iPhone 5c",
                                "iPhone6,1" : "iPhone 5s",
                                "iPhone6,2" : "iPhone 5s",
                                "iPhone7,1" : "iPhone 6 Plus",
                                "iPhone7,2" : "iPhone 6",
                                "iPhone8,1" : "iPhone 6s",
                                "iPhone8,2" : "iPhone 6s Plus",
                                "iPhone8,4" : "iPhone SE",
                                "iPhone9,1" : "iPhone 7",
                                "iPhone9,2" : "iPhone 7 Plus",
                                "iPhone9,3" : "iPhone 7",
                                "iPhone9,4" : "iPhone 7 Plus",
                                "iPhone10,1": "iPhone 8",
                                "iPhone10,2": "iPhone 8 Plus",
                                "iPhone10,3": "iPhone X",
                                "iPhone10,4": "iPhone 8",
                                "iPhone10,5": "iPhone 8 Plus",
                                "iPhone10,6": "iPhone X",
                                "iPhone11,2": "iPhone Xs",
                                "iPhone11,4": "iPhone Xs Max",
                                "iPhone11,6": "iPhone Xs Max",
                                "iPhone11,8": "iPhone Xr",
                                "iPhone12,1": "iPhone 11",
                                "iPhone12,3": "iPhone 11 Pro",
                                "iPhone12,5": "iPhone 11 Pro Max",
                                "iPhone12,8": "iPhone SE",
                                "iPhone13,1": "iPhone 12 mini",
                                "iPhone13,2": "iPhone 12",
                                "iPhone13,3": "iPhone 12 Pro",
                                "iPhone13,4": "iPhone 12 Pro Max",
                                
                                "iPad1,1" : "iPad 1",
                                "iPad2,1" : "iPad 2 (WiFi)",
                                "iPad2,2" : "iPad 2 (GSM)",
                                "iPad2,3" : "iPad 2 (CDMA)",
                                "iPad2,4" : "iPad 2",
                                "iPad2,5" : "iPad mini 1",
                                "iPad2,6" : "iPad mini 1",
                                "iPad2,7" : "iPad mini 1",
                                "iPad3,1" : "iPad 3 (WiFi)",
                                "iPad3,2" : "iPad 3 (4G)",
                                "iPad3,3" : "iPad 3 (4G)",
                                "iPad3,4" : "iPad 4",
                                "iPad3,5" : "iPad 4",
                                "iPad3,6" : "iPad 4",
                                "iPad4,1" : "iPad Air",
                                "iPad4,2" : "iPad Air",
                                "iPad4,3" : "iPad Air",
                                "iPad4,4" : "iPad mini 2",
                                "iPad4,5" : "iPad mini 2",
                                "iPad4,6" : "iPad mini 2",
                                "iPad4,7" : "iPad mini 3",
                                "iPad4,8" : "iPad mini 3",
                                "iPad4,9" : "iPad mini 3",
                                "iPad5,1" : "iPad mini 3",
                                "iPad5,2" : "iPad mini 4",
                                "iPad5,3" : "iPad Air 2",
                                "iPad5,4" : "iPad Air 2",
                                "iPad6,3": "iPad mini 5",
                                "iPad6,4": "iPad Pro (9.7-inch)",
                                "iPad6,7": "iPad Pro (9.7-inch)",
                                "iPad6,8": "iPad Pro (12.9-inch)",
                                "iPad6,11": "iPad 5",
                                "iPad6,12": "iPad 5",
                                "iPad7,1": "iPad Pro (12.9-inch)",
                                "iPad7,2": "iPad Pro (12.9-inch)(2nd generation)",
                                "iPad7,3": "iPad Pro (12.9-inch)(2nd generation)",
                                "iPad7,4": "iPad Pro (10.5-inch)",
                                "iPad7,5": "iPad 5",
                                "iPad7,6": "iPad 6",
                                "iPad7,11": "iPad Air 3",
                                "iPad7,12": "iPad 7",
                                "iPad8,1": "iPad Pro (10.5-inch)",
                                "iPad8,2": "iPad Pro (10.5-inch)",
                                "iPad8,3": "iPad Pro (10.5-inch)",
                                "iPad8,4": "iPad Pro (11-inch)",
                                "iPad8,5": "iPad Pro (11-inch)",
                                "iPad8,6": "iPad Pro (11-inch)",
                                "iPad8,7": "iPad Pro (11-inch)",
                                "iPad8,8": "iPad Pro (12.9-inch)(3nd generation)",
                                "iPad11,1": "iPad mini 4",
                                "iPad11,2": "iPad mini 5",
                                "iPad11,3": "iPad 6",
                                "iPad11,4": "iPad Air 3",
                                
                                "AudioAccessory1,1" : "HomePod",
                                
                                "i386" : "Simulator x86",
                                "x86_64" : "Simulator x64"]
    }
}


// MARK: - Network
/// Network
public extension UIDevice {
    
    /// 返回设备WiFi的IP地址(可能为零)，如"192.168.1.111"
    var sp_WIFIIpAddress: String? {
        return self._sp_ipAddressWithIfa(name: "en0", family: sa_family_t(AF_INET))
    }
    
    /// 返回设备WiFi在IPv6下的IP地址，如"fe80::86:c7fa:c1c4:dfd7"
    var sp_WIFIIPv6Address: String? {
        return self._sp_ipAddressWithIfa(name: "en0", family: sa_family_t(AF_INET6))
    }
    
    /// 返回设备网络的IP地址(可能为零)，如"10.2.2.222"
    var sp_ipAddressCell: String? {
        return self._sp_ipAddressWithIfa(name: "pdp_ip0", family: sa_family_t(AF_INET))
    }
    
    
    private func _sp_ipAddressWithIfa(name: String, family: sa_family_t) -> String? {
        let addrs = UnsafeMutablePointer<UnsafeMutablePointer<ifaddrs>?>.allocate(capacity: 1)
        var address: String?
        
        if getifaddrs(addrs) == 0 {
            var addr: ifaddrs? = addrs.pointee?.pointee
            while (addr != nil) {
                if String(utf8String: addr!.ifa_name) == name {
                    if (family == addr!.ifa_addr.pointee.sa_family) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        var sockaddr = addr!.ifa_addr.pointee
                        if (getnameinfo(&sockaddr, socklen_t(sockaddr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let hostString = String(validatingUTF8: hostname) {
                                address = hostString
                            }
                        }
                    }
                    
                    if address != nil { break }
                }
                if addr!.ifa_next == nil { break }
                else { addr = addr?.ifa_next.pointee }
            }
        }
        
        freeifaddrs(addrs.pointee)
        addrs.deallocate()
        return address
    }
    
    /// 返回设备的Mac地址，如"20:00:00:00:ef:00"
    var sp_macAddress: String? {
        let index = Int32(if_nametoindex("en0"))
        if index == 0 { return nil }

        var mib: [Int32] = [CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, index]
        var len = 0
        if sysctl(&mib, UInt32(mib.count), nil, &len, nil,0) < 0 { return nil }
        
        var buffer = [CChar].init(repeating: 0, count: len)
        if sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) < 0 { return nil }
        
        let bsdData = "en0".data(using: .utf8)!
        let infoData = NSData(bytes: buffer, length: len)
        
        // (struct if_msghdr *)buffer
        var interfaceMsgStruct = if_msghdr()
        infoData.getBytes(&interfaceMsgStruct, length: MemoryLayout.size(ofValue: if_msghdr()))
        
        // (struct sockaddr_dl *)(ifm + 1);
        let socketStructStart = MemoryLayout.size(ofValue: if_msghdr()) + 1
        let socketStructData = infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart))
        
        // (unsigned char *)LLADDR(sdl);
        let rangeOfToken = socketStructData.range(of: bsdData, options: NSData.SearchOptions(rawValue: 0), in: Range.init(uncheckedBounds: (0, socketStructData.count)))
        let start = rangeOfToken?.upperBound ?? 6
        let end = start + 6
        let range1 = start..<end
        var macAddressData = socketStructData.subdata(in: range1)
        let macAddressDataBytes: [UInt8] = [UInt8](repeating: 0, count: 6)
        macAddressData.append(macAddressDataBytes, count: 6)
        return String(format: "%02X:%02X:%02X:%02X:%02X:%02X", macAddressData[0], macAddressData[1], macAddressData[2], macAddressData[3], macAddressData[4], macAddressData[5])
    }
}


//MARK: - Disk
/// Disk
public extension UIDevice {
    
    /// 返回iPhone磁盘的总大小(bytes)
    var sp_diskSpace: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return (attrs[FileAttributeKey.systemSize] as? Int64) ?? -1
        } catch {
            return -1
        }
    }
    
    /// 返回iPhone磁盘的总大小的描述
    var sp_diskSpaceDescribe: String {
        return ByteCountFormatter.string(fromByteCount: self.sp_diskSpace, countStyle: .file)
    }
    
    /// 返回iPhone磁盘的剩余(可用)空间大小(bytes)
    var sp_diskSpaceFree: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return (attrs[FileAttributeKey.systemFreeSize] as? Int64) ?? -1
        } catch {
            return -1
        }
    }
    
    /// 返回iPhone磁盘的剩余空间大小的描述
    var sp_diskSpaceFreeDescribe: String {
        return ByteCountFormatter.string(fromByteCount: self.sp_diskSpaceFree, countStyle: .file)
    }
    
    /// 返回iPhone磁盘的已用空间大小(bytes)
    var sp_diskSpaceUsed: Int64 {
        let total = self.sp_diskSpace
        let free = self.sp_diskSpaceFree
        if total < 0 || free < 0 { return -1 }
        var used = total - free
        if used < 0 { used = -1 }
        return used
    }
    
    /// 返回iPhone磁盘的已用空间大小的描述
    var sp_diskSpaceUsedDescribe: String {
        return ByteCountFormatter.string(fromByteCount: self.sp_diskSpaceUsed, countStyle: .file)
    }
    
}
