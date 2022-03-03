//
//  NoDataView.swift
//  1xpocket
//
//  Created by Apple on 2020/12/25.
//

import UIKit

class NoDataView: UIView {
    
    lazy var noDataImgView: UIImageView = {
        let noDataImgView = UIImageView()
        return noDataImgView
    }()
    
    lazy var noDataLab: UILabel = {
        let noDataLab = UILabel()
        noDataLab.textColor = UIColor("#8DA0AE")
        noDataLab.font = UIFont.PUHUIRegular(size: 15)
        noDataLab.textAlignment = .center
        noDataLab.numberOfLines = 0
        return noDataLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(noDataImgView)
        self.addSubview(noDataLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(imageName: String, title: String) {
        
        noDataImgView.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        if !stringIsEmpty(imageName) {
            
            guard let image = UIImage(named: imageName) else {
                return
            }
            
            noDataImgView.image = image
            noDataImgView.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            noDataImgView.center = CGPoint(x: self.center.x, y: noDataImgView.view_height / 2)
        }
        
        noDataLab.text = title
        let labSize = title.size(size: CGSize(width: self.view_width - 120, height: CGFloat.greatestFiniteMagnitude), font: noDataLab.font)
        noDataLab.frame = CGRect(x: 60, y: noDataImgView.view_bottom + 8, width: self.view_width - 120, height: labSize.height)
        
        self.frame = CGRect(x: self.view_left, y: self.view_top, width: self.view_width, height: noDataLab.view_bottom)
    }
    
}
