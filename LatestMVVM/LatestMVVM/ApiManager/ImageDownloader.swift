//
//  ImageDownloader.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 07/08/24.
//

import Foundation
import UIKit

class ImageDownloader: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    private var dataTask: URLSessionDataTask?
    private var session: URLSession?
    private var progressHandler: ((Double) -> Void)?
    private var completionHandler: ((UIImage?, Error?) -> Void)?
    private var downloadedData = Data()
    
    func downloadImage(from url: URL, progress: @escaping (Double) -> Void, completion: @escaping (UIImage?, Error?) -> Void) {
        self.progressHandler = progress
        self.completionHandler = completion
        
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask = session?.dataTask(with: request)
        dataTask?.resume()
    }
    
    // URLSessionDataDelegate Methods
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
        // Initialize data container
        downloadedData = Data()
        // Here you might want to check the response to ensure it is valid, e.g., HTTP response code
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // Append data to downloadedData
        downloadedData.append(data)
        
        // Update progress
        if let totalBytesExpected = dataTask.response?.expectedContentLength {
            let totalBytesReceived = Int64(downloadedData.count)
            let progress = Double(totalBytesReceived) / Double(totalBytesExpected)
            progressHandler?(progress)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completionHandler?(nil, error)
            return
        }
        
        // Convert downloadedData to UIImage
        let image = UIImage(data: downloadedData)
        completionHandler?(image, nil)
    }
}
