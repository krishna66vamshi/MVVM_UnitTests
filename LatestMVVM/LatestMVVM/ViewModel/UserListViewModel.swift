//
//  UserListViewModel.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 05/01/24.
//

import Foundation

enum Event {
    case loading
    case stopLoading
    case dataLoaded
    case error(String)
}

class UserViewModel{
    var description,title,thumb:String?
    
    init(source :UserModel) {
        self.description = source.description
        self.title = source.title
        self.thumb = source.thumb
    }
}

class UserListViewModel{
    
    var webservice:APIServiceProtocol
    var eventHandler:((_ event:Event) -> ())?
    var userViewModel = [UserViewModel]()
    
    init(webservice: APIServiceProtocol = APIManager()) {
        self.webservice = webservice
    }
    
    func fetchUserData(){
        DispatchQueue.main.async {
            self.eventHandler?(.loading)
        }
        let url = "https://interview-e18de.firebaseio.com/media.json?print=pretty"
        webservice.callAPI(url: url, modelType: [UserModel].self) { result in
            DispatchQueue.main.async {
                self.eventHandler?(.stopLoading)
            }
            switch result {
            case .success(let success):
                self.userViewModel = success.map(UserViewModel.init)
                DispatchQueue.main.async {
                    self.eventHandler?(.dataLoaded)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.eventHandler?(.error(failure.localizedDescription))
                }
            }
        }
    }
    
    func downloadImage(url:String,completion:@escaping(Data?,Error?)->()){
        APIManager.downloadImage(url: url) { result in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(nil,failure)
            }
        }
    }
    
    func getUserViewModel(at indexPath: IndexPath) -> UserViewModel {
        return userViewModel[indexPath.row]
    }

    
    
}

