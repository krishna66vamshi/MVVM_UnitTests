//
//  ImageDownloaderViewController.swift
//  LatestMVVM
//
//  Created by Hyper Thread Solutions Pvt Ltd on 07/08/24.
//

import UIKit

class ImageDownloaderViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .red
            progressView.progress = 0.0
          
            
            // Setup layout for imageView and progressView here
            
            let imageURL = URL(string: "https://www.sefram.com/images/products/photos/hi_res/5352DC.jpg")!
            
            let downloader = ImageDownloader()
            
            downloader.downloadImage(from: imageURL, progress: { [weak self] progress in
                DispatchQueue.main.async {
                    self?.progressView.progress = Float(progress)
                }
            }, completion: { [weak self] image, error in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                        self?.progressView.isHidden = true
                    }
                } else if let error = error {
                    print("Download error: \(error.localizedDescription)")
                }
            })
        }
    }

