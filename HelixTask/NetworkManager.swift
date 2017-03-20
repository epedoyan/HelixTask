//
//  NetworkManager.swift
//  HelixTask
//
//  Created by Codefights on 3/15/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

private let kURL = "https://www.helix.am/temp/json.php"

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    private var session: URLSession?

    override init() {
        super.init()
        session = URLSession.shared
    }
    
    func loadNews(completionHandler: @escaping ([NewsItem]?) -> ()) {
        let request = URLRequest(url: URL(string: kURL)!)
        let task = session?.dataTask(with: request) { (data, response, error) in
            var items: [NewsItem]?
            if let data = data {
                if let dataDictionary = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String : Any] {
                    if let itemsData = dataDictionary["metadata"] as? [[String : Any]] {
                        items = [NewsItem]()
                        for item in itemsData {
                            let newsItem = NewsItem(withDictionary: item)
                            items!.append(newsItem)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler(items)
            }
        }
        task?.resume()
    }
    
    func downloadImageAtURL(_ imageUrl: String, completionHandler: @escaping (UIImage) -> Void) {
        let imageURL = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                completionHandler(UIImage(data: data!)!)
            }
        }
    }
}
