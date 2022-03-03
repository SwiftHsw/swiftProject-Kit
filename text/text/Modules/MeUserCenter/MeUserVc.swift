//
//  MeUserVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/3.
//

import UIKit
import PromiseKit

class MeUserVc: SBaseVc {

    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    
    
    let dataSource : [[String]] = [["交易记录","地址簿","钱包管理","商家入驻","计价单位"],["设定","帮助与反馈","关于我们","版本更新"]]
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHiddenNavBar = true
        view.backgroundColor = ColorF6FAFD
        navHeight.constant = StatusBarAndNavigationBarHeight
       
    }
    
    override func setupViews(){
        tableV.separatorColor = .clear
        tableV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 28, right: 0)
        tableV.contentInsetAdjustmentBehavior = .never
    }
     
 
    @IBAction func didPushUserInfoVc(_ sender: Any) {
        
        sPush(name: "Main", identifer: UserInfoVc.className) { (vc: UserInfoVc) in
             
        }
        
    }
}


extension MeUserVc : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withType: MeUserCell.self, for: indexPath)
  
        cell.textL.text = dataSource[indexPath.section][indexPath.row]
         
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataSource[section]
        return arr.count
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          
        let y = scrollView.contentOffset.y
        let alpha = y / 30
        
        print(y)
        if y < 5{
            navTitle.alpha = 0
            navView.backgroundColor = UIColor("FFFFFF", alpha: 0)
        }else if y > 30 {
            navTitle.alpha = 1
            navView.backgroundColor = UIColor("FFFFFF", alpha: 1)
        }else{
            navView.backgroundColor = UIColor("FFFFFF", alpha: alpha)
            navTitle.alpha = alpha
        }
         
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 8 : TabBarAndSafeBottomMargin + 36
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section,indexPath.row){
            
        case (0,0):
            print(indexPath)
            
        case (0,1):
            print(indexPath)
            
        case (0,2):
            print(indexPath)
            
            
        case (0,3):
            print(indexPath)
            
        case (0,4):
            print(indexPath)
            
        default:break
        }
        
    }
    
    
}
