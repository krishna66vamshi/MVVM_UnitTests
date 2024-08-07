//
//  UserTableViewCell.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 05/01/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userTitleLbl: UILabel!
    
    @IBOutlet weak var userDescLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setupCell(userViewModel:UserViewModel){
        userTitleLbl.text = userViewModel.title ?? ""
        userDescLbl.text = userViewModel.description ?? ""
        
       
    }
    
}
