//
//  secondViewC.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import UIKit
import HWPanModal


class secondViewC: AlertVC {
 
    var didselectBlock : BlockWithParameters<IndexPath>?
    lazy var customsData: [String] = {
        let arr = ["ETH","BTC","USDT","TRX","ETH","BTC","USDT","TRX","ETH","BTC","USDT","TRX"]
        return arr
    }()
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var butt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.tableV.register(secondViewCell.self)
        self.tableV.rowHeight = 50
        tableV.tableFooterView = UIView()
        
    }
    
    @IBAction func ationBlock(_ sender: Any) {
    
        
       hide()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}
//MARK: -HWPanModalPresentable

extension secondViewC {
    
    
    override func longFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height:  ScreenHeight*0.7)
    }
    override func shortFormHeight() -> PanModalHeight {
        return PanModalHeight(type: .content, height: ScreenHeight*0.4)
    }
    
    override func showDragIndicator() -> Bool {
        return false
    }
    
    override func cornerRadius() -> CGFloat {
        return 15
    }
    
    override func panScrollable() -> UIScrollView? {
        return tableV
    }
    
}


extension secondViewC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: secondViewCell.self, for: indexPath)
        let text = self.customsData[indexPath.row]
        cell.tileName.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        tableView.deselectRow(at: indexPath, animated: true)
        didselectBlock?(indexPath)
        
        
        
    }
}
