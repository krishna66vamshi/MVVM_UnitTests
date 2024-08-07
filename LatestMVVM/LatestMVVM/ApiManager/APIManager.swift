//
//  APIManager.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 05/01/24.
//

import Foundation

enum NetworkError: Error {
    case noDataFound
    case invalidStatusCode
    case invalidURL
    case network(Error?)
    case decoding(Error?)
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .noDataFound:
            return "Data Not Found"
        case.invalidStatusCode:
            return "Invalid Status Code"
        case .invalidURL:
            return "Invalid URL"
        case let .network(error):
            return "Something went wrong, please try again later:\(error?.localizedDescription ?? "")"
        case let .decoding(error):
            return "JSON could not be decoded because of error:\(error?.localizedDescription ?? "")"
        }
    }
}

protocol APIServiceProtocol {
    func callAPI<T:Codable>(
        url:String,
        modelType:T.Type,
        completionHandler: @escaping(Result<T, NetworkError>) -> ())
}

class APIManager:APIServiceProtocol{
    
    func callAPI<T>(url: String, modelType: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> ()) where T : Decodable, T : Encodable {
        let url = URL(string: url)!
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data else{
                return completionHandler(.failure(.noDataFound))
            }
            
            guard let httpResponse = resp as? HTTPURLResponse,httpResponse.statusCode == 200 else {
                return completionHandler(.failure(.invalidStatusCode))
            }
            
            do{
                let response = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(response))
            }catch let decodingErr{
                completionHandler(.failure(.decoding(decodingErr)))
            }
        }.resume()
        
    }
    
    static func downloadImage(
        url:String,
        completionHandler: @escaping(Result<Data, NetworkError>) -> ()){
        let url = URL(string: url)!
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data else{
                return completionHandler(.failure(.noDataFound))
            }
                        
            guard let httpResponse = resp as? HTTPURLResponse,httpResponse.statusCode == 200 else {
                return completionHandler(.failure(.invalidStatusCode))
            }
            completionHandler(.success(data))
        }.resume()
        
    }
    
    
}
