//
//  HomeTableCell.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var dertailable: UILabel!
    var model : sampleModel? {
        didSet{
            dertailable.text = model?.from
        }
        willSet{
            print("willSet ===\(model?.from)")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
