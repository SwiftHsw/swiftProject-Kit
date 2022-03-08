//
//  GoolegeVC.swift
//  text
//
//  Created by 黄世文 on 2022/3/7.
//

import UIKit
import GoogleMaps
import sqlcipher


class GoolegeVC: SBaseVc  {

    @IBOutlet weak var mapView: GMSMapView!
    
    var currentCenter: CLLocationCoordinate2D?
    var isRequest = false
    var circle: GMSCircle?
    var btmMarkers: [GMSMarker] = []
    
    var selectMarker: GMSMarker? {
        didSet {
           print("选中某一个大头针")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.isHiddenNavBar = true
        
        
        //判断定位权限
        updatePermissionShow()
        LocationUtil.share.permissionChangeBlock = { [weak self] in
            self?.updatePermissionShow()
        }
        LocationUtil.share.locationBlock = { [weak self] tuple in
            
//            guard (self?.isNeedLocation ?? false) else {
//                return
//            }
            
            let camera = GMSCameraPosition.camera(withLatitude: tuple.0, longitude: tuple.1, zoom: 15)
            self?.mapView.animate(to: camera)
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if let coordinate = self.mapView.myLocation?.coordinate {
                    let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
                    self.mapView.camera = camera
                }
            }
        }
        
    }
     
    
    override func setupViews() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //添加模糊阴影
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: StatusBarHeight)
        self.view.addSubview(blurView)
        
    }
    
    
    func loadData(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        guard !isRequest else {
            return
        }
        
        isRequest = true
        
        //传入当前经纬度 获取大头针标注
        var details: [BTMDetailModel] = []
        //ptional(118.1779224504533) 获取到纬度: Optional(24.511820803250203)
        let model1 = BTMDetailModel()
        model1.lat = "118.1779224504534"
        model1.lon = "24.511820803250202"
        details.append(model1)
        
        let model2 = BTMDetailModel()
        model2.lat = "118.1779224504535"
        model2.lon = "24.511820803250201"
        details.append(model2)
        
        let model3 = BTMDetailModel()
        model3.lat = "118.1779224504536"
        model3.lon = "24.511820803250202"
        details.append(model3)
        
        
        let model4 = BTMDetailModel()
        model4.lat = "118.1779224504536"
        model4.lon = "24.511820803250201"
        details.append(model4)
        
         
        
        self.setupMarkers(details: details)
        
//        AssetsRequest.peripheryList(lat: "\(lat)", lon: "\(lon)").done { result in
//            if let details = result.modelArray {
//                self.setupMarkers(details: details)
//            }
//        }.catch { error in
//            guard let requestError = error as? RequestError else { return }
//            WidgetUtil.share.showTip(str: requestError.message)
//        }.finally {
//            self.isRequest = false
//        }
    }
    /// 设置annotations
    func setupMarkers(details: [BTMDetailModel]) {
        
        //绘制 这个 GMSMarker 多个对象
        // 筛选GMSMarker
        var tempMarkers: [GMSMarker] = []
        for detail in details {
//            let filter = btmMarkers.filter { marker in
//                let detailModel = marker.userData as? BTMDetailModel
//                return detailModel?.pic == detail.pic
//            }
            let lat = Double(detail.lat) ?? 0
            let lon = Double(detail.lon) ?? 0
//            if arrayIsEmpty(arr: details), let lat = Double(detail.lat), let lon = Double(detail.lon) {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 52))
                iconView.image = UIImage(named: detail.annotationImgName)
                marker.iconView = iconView
                marker.userData = detail
                marker.map = mapView
                tempMarkers.append(marker)
//            }
        }
        btmMarkers.append(contentsOf: tempMarkers)
    }
    
    func updatePermissionShow(){
        
        LocationUtil.share.requestLocation()
        
//        if LocationUtil.share.hasLocationPermission() {
//            LocationUtil.share.requestLocation()
//        } else {
//            print("暂时无法获取当前定位, 请前往-设置-获取位置权限")
//        }
      
    }
    
    /// 改变圆圈位置
    func showCircleChange(coordinate: CLLocationCoordinate2D) {
        
        guard let circle = self.circle else {
            
            self.circle = GMSCircle(position: coordinate, radius: 500)
            self.circle?.strokeWidth = 0
            self.circle?.fillColor = UIColor("#3090DD").withAlphaComponent(0.1)
            self.circle?.map = mapView
            
            return
        }
        
        circle.position = coordinate
    }
    /// 取消选中状态
    func deSelectMarkerChange() {
        
        guard let selectMarker = self.selectMarker,
              let selectDetail = self.selectMarker?.userData as? BTMDetailModel,
              let iconView = selectMarker.iconView as? UIImageView else {
            return
        }
        
//        selectDetail.isSelect.toggle()
//        iconView.image = UIImage(named: selectDetail.annotationImgName)
        self.selectMarker = nil
    }

}

extension GoolegeVC : GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        currentCenter = position.target
        // 加载附近的BTM
        loadData(lat: position.target.latitude, lon: position.target.longitude)
        // 改变圆圈位置
        showCircleChange(coordinate: position.target)
        // 重新搜索
//        if isShouldUpdateSearch {
//            searchVC?.updateLocation(loc: position.target)
//        } else {
//            isShouldUpdateSearch = true
//        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // 取消选中状态
        deSelectMarkerChange()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // 取消选中状态
        deSelectMarkerChange()
        // 设置选中状态
        if let detail = marker.userData as? BTMDetailModel,
           let iconView = marker.iconView as? UIImageView {
//            detail.isSelect.toggle()
//            iconView.image = UIImage(named: detail.annotationImgName)
            self.selectMarker = marker
        }
        return true
    }
    
    
}

class BTMDetailModel:BaseModel,Copyable{
    
    /// 封面
    var cover = ""
    /// btm地址
    var address = ""
    /// 联系人名称
    var contactPerson = ""
    /// facebook
    var facebook = ""
    /// 电报
    var telegram = ""
    /// 安装工作站
    var whatsapp = ""
    /// 距离
    var distanceCompany = ""
    /// 开始营业时间（00:00）
    var startTime = ""
    /// 结束营业时间（24:00）
    var endTime = ""
    /// 纬度
    var lat = ""
    /// 经度
    var lon = ""
    /// btm商户名称
    var name = ""
    /// 图片
    var pic = ""
    /// 是否可取款 0否 1是
    var status = false
    
    // MARK: - 本地使用
    
    var isSelect = false
    
    var annotationImgName: String {
        return isSelect ? "btm_annotation_select" : "btm_annotation"
    }
    
    var imageStrs: [String] {
        if stringIsEmpty(pic) {
            return []
        }
        return pic.components(separatedBy: ",")
    }
    
    
}
