//
//  ViewController.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 05/01/24.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    var viewModel:UserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserListViewModel(webservice: APIManager())
        setupViewModel()
    }
    
    func setupViewModel(){
        viewModel.fetchUserData()
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                self.loader.startAnimating()
            case .stopLoading:
                self.loader.stopAnimating()
            case .dataLoaded:
                self.tableView.reloadData()
            case .error(let error):
                self.showAlert(error)
            }
        }
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else { return .init() }
        
        cell.setupCell(userViewModel: viewModel.getUserViewModel(at: indexPath))
        let imgUrl = viewModel.userViewModel[indexPath.row].thumb ?? ""
        viewModel.downloadImage(url: imgUrl) { data, _ in
            if let data = data{
                DispatchQueue.main.async {
                    cell.userImgView.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        detailsVC.userVM = viewModel.getUserViewModel(at: indexPath)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}

