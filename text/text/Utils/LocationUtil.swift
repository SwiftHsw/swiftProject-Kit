//
//  LocationUtil.swift
//  1xpocket
//
//  Created by 吴垠锋 on 2022/1/10.
//

import Foundation
import MapKit

let UserLoginNC = NSNotification.Name("UserLoginNC")


class LocationUtil: NSObject {
    
   
    static let share = LocationUtil()
    
    /// 权限变更回调
    public var permissionChangeBlock: BlockWithNone?
    /// 经纬度回调
    public var locationBlock: BlockWithParameters<(CLLocationDegrees, CLLocationDegrees)>?
    
    public lazy var locationMgr: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        mgr.distanceFilter = 50
        mgr.delegate = self
        return mgr
    }()
    
    private var longitude: CLLocationDegrees? // 经度
    private var latitude: CLLocationDegrees? // 纬度
    private var isSavePosition = false
    
    private override init() {
        super.init()
        
        // 用户登录成功, 上传位置
        NotificationCenter.default.addObserver(self, selector: #selector(saveUserPosition), name: UserLoginNC, object: nil)
    }
    
    // MARK: - Public
    
    /// APP是否有定位权限
    public func hasLocationPermission() -> Bool {
        switch locationPermission() {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            break
        }
        return false
    }
    
    /// 请求一次性定位
    public func requestLocation() {
        if hasLocationPermission() {
            locationMgr.requestLocation()
        } else {
            locationMgr.requestWhenInUseAuthorization()
        }
    }
    
    /// 请求持续定位
    public func startUpdatingLocation() {
        if hasLocationPermission() {
            locationMgr.startUpdatingLocation()
        } else {
            locationMgr.requestWhenInUseAuthorization()
        }
    }
    
    /// 停止持续定位
    public func stopUpdatingLocation() {
        locationMgr.stopUpdatingLocation()
    }
    
    // MARK: - Private
    
    /// 更新用户位置
    @objc private func saveUserPosition() {
        
        guard !isSavePosition else {
            return
        }
        
//        guard UserUtil.share.isLogin(), let lat = latitude, let lon = longitude else {
//            return
//        }
//
//        UserRequest.saveUserPosition(lat: "\(lat)", lon: "\(lon)").done { result in
//            self.isSavePosition = true
//        }.catch { (error) in
//        }
    }
    
    /// 定位的权限
    private func locationPermission() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            let status: CLAuthorizationStatus = locationMgr.authorizationStatus
            return status
        } else {
            let status = CLLocationManager.authorizationStatus()
            return status
        }
    }
    
}

extension LocationUtil: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        // 更新用户位置
        saveUserPosition()
        
        // 回调经纬度
        if let lat = latitude, let lon = longitude {
            locationBlock?((lat, lon))
        }
        
        SLog(">>>>>>>>> 获取到经度: \(String(describing: longitude)) 获取到纬度: \(String(describing: latitude))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SLog("定位失败 \(error)")
        locationMgr.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        SLog("定位授权状态 -> \(status)")
        switch status {
        case .notDetermined: // 用户没有决定是否使用定位服务。
            break
        case .restricted: // 定位服务授权状态是受限制的。
            break
        case .denied: // 定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭。
            break
        case .authorizedAlways: // 定位服务授权状态已经被用户允许在任何状态下获取位置信息。
            requestLocation()
        case .authorizedWhenInUse: // 定位服务授权状态仅被允许在使用应用程序的时候。
            requestLocation()
        default:
            break
        }
        
        permissionChangeBlock?()
    }
    
}
