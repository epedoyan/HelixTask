//
//  NewsItem.swift
//  HelixTask
//
//  Created by Codefights on 3/18/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class NewsItem: NSObject {
    
    var category: String?
    var title: String?
    var date: String?
    var imageURL: String?
    var image: UIImage?
    var body: String?
    var galleryThumbnailsURLs: [String]?
    var videosThumbnailsURLs: [[String: String]]?

    init(withDictionary item: [String : Any]) {
        self.category = item["category"] as? String
        self.title = item["title"] as? String
        self.body = item["body"] as? String
        self.imageURL = item["coverPhotoUrl"] as? String
        let timeInterval = item["date"] as? TimeInterval
        self.date = timeInterval?.dateString()
        if let imageURLsArray = item["gallery"] as? [[String : String]] {
            self.galleryThumbnailsURLs = [String]()
            for item in imageURLsArray {
                self.galleryThumbnailsURLs!.append(item["thumbnailUrl"]!)
            }
        }
        if let videosURLsArray = item["video"] as? [[String : String]] {
            self.videosThumbnailsURLs = [[String: String]]()
            for item in videosURLsArray {
                let dict: [String: String] = ["thumbnailUrl":  item["thumbnailUrl"]! , "youtubeId": item["youtubeId"]!]
                self.videosThumbnailsURLs!.append(dict)
            }
        }
    }
    
    func loadImage(completionHandler: @escaping (UIImage?) -> Void) {
        if let urlString = imageURL, let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    self?.image = UIImage(data: data)
                }
                DispatchQueue.main.async { [weak self] in
                    completionHandler(self?.image)
                }
            }
        }
    }
}

extension TimeInterval {
    
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}
