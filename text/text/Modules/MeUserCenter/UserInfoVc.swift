//
//  UserInfoVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/3.
//

import UIKit

class UserInfoVc: SBaseTableViewVC {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHeadImage: UIImageView!
    
    @IBOutlet weak var userId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "个人信息"
        userId.text = "3922871"
        userName.text = "用户昵称9岁"
    }
 
}


extension UserInfoVc{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
      
        let label = UILabel()
        label.textColor = Color5C686D
        label.font = UIFont.PUHUIRegular(size: 13)
        label.text = "基本资讯" 
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(view.snp.centerY)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}
