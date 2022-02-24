 //
//  UITableViewCell+Extend.swift
//  Gregarious
//
//  Created by Admin on 2021/3/26.
//

import UIKit

extension UITableViewCell {
    
    /// 添加以Section为整体的圆角
    func addSectionCornerWith(tableView: UITableView, indexPath: IndexPath, cornerRadius: CGFloat, margin: CGFloat = 0, fillColor: UIColor = .white) {
        let pathRef = CGMutablePath()
        let bounds = self.bounds
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 每组只有一行的时候 */
            pathRef.move(to: CGPoint(x: bounds.midX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.minX + margin, y: bounds.midY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
        }
        else if indexPath.row == 0 {
            /** 第一行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.maxY))
        }
        else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 最后一行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX + margin, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.minY))
            
        }
        else if indexPath.row != 0 && indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 每组中间的行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.minY))
            pathRef.addLine(to: CGPoint(x: bounds.minX + margin, y: bounds.maxY))
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.maxY))
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.minY))
        }
        
        let layer = CAShapeLayer()
        layer.path = pathRef
        layer.fillColor = fillColor.cgColor
        let backView = UIView(frame: bounds)
        backView.layer.addSublayer(layer)
        backView.backgroundColor = .clear
        self.backgroundView = backView
    }
    
    func addSectionCornerWith(tableView: UITableView, indexPath: IndexPath, margin: CGFloat = 0, fillColor: UIColor = .white, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
        let pathRef = CGMutablePath()
        let bounds = self.bounds
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 每组只有一行的时候 */
            pathRef.move(to: CGPoint(x: bounds.midX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.minX + margin, y: bounds.midY), radius: bottomLeftRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: topLeftRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: topRightRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: bottomRightRadius)
        }
        else if indexPath.row == 0 {
            /** 第一行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: topLeftRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: topRightRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.maxY))
        }
        else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 最后一行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX + margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX + margin, y: bounds.maxY), radius: bottomLeftRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX - margin, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX - margin, y: bounds.midY), radius: bottomRightRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.minY))
            
        }
        else if indexPath.row != 0 && indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            /** 每组中间的行 */
            pathRef.move(to: CGPoint(x: bounds.minX + margin, y: bounds.minY))
            pathRef.addLine(to: CGPoint(x: bounds.minX + margin, y: bounds.maxY))
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.maxY))
            pathRef.addLine(to: CGPoint(x: bounds.maxX - margin, y: bounds.minY))
        }
        
        let layer = CAShapeLayer()
        layer.path = pathRef
        layer.fillColor = fillColor.cgColor
        let backView = UIView(frame: bounds)
        backView.layer.addSublayer(layer)
        backView.backgroundColor = .clear
        self.backgroundView = backView
    }
    
}
