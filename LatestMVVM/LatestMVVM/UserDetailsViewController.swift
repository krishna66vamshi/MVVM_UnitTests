//
//  UserDetailsViewController.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 05/01/24.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var userTitleLbl: UILabel!
    
    var userVM:UserViewModel?
    var userDetailsVM:UserDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTitleLbl.text = userVM?.title ?? ""
        setupViewModel()
    }
    
    func setupViewModel(){
        if let userVM = userVM{
           _ = UserDetailsViewModel(userViewModel: userVM)
        }
    }
}
