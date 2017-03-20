//
//  Cell.swift
//  HelixTask
//
//  Created by Codefights on 3/15/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet private weak var categoryLabel: UILabel! 
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    private var item: NewsItem?
    
    func setNewsItem(_ newsItem: NewsItem, forRow row: Int) {
        item = newsItem
        categoryLabel.text = newsItem.category
        titleLabel.text = newsItem.title
        dateLabel.text = newsItem.date
        if let image = newsItem.image {
            thumbnailImageView.image = image
        } else {
            newsItem.loadImage(completionHandler: { [weak self] (image) in
                if self?.item?.imageURL == newsItem.imageURL {
                    self?.thumbnailImageView.image = image
                    NotificationCenter.default.post(name: Notification.Name(rawValue:"imageIsLoaded"), object: nil, userInfo:["image" : image!, "row": row])
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = ""
        titleLabel.text = ""
        dateLabel.text = ""
        thumbnailImageView.image = nil
        backgroundColor = nil
    }
}
