//
//  DetailViewController.swift
//  HelixTask
//
//  Created by Codefights on 3/15/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var galleryButton: UIButton!
    @IBOutlet private weak var videosButton: UIButton!
    
    var newsItem: NewsItem?
    var selectedCellRow: Int?
    
    func configureView() {
        titleLabel.text = newsItem?.title
        do {
            if let body = newsItem?.body {
                descriptionTextView.attributedText = try NSAttributedString(data: (body.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            }
        } catch {
            print(error)
        }
        dateLabel.text = newsItem?.date
        navigationItem.title = newsItem?.category
        coverImageView.image = newsItem?.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(imageLoadedHandling(_:)), name: Notification.Name(rawValue:"imageIsLoaded"), object: nil)
        if newsItem?.galleryThumbnailsURLs == nil {
            galleryButton.isHidden = true
        }
        if newsItem?.videosThumbnailsURLs == nil {
            videosButton.isHidden = true
        }

    }
    
    func imageLoadedHandling(_ notification: Notification) {
        let userInfo = notification.userInfo as? [String : Any]
        let image = userInfo?["image"] as? UIImage
        let selectedRow = userInfo?["row"] as? Int
        if(selectedRow == selectedCellRow) {
            self.coverImageView.image = image
        }
    }
    
    @IBAction func videosButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "gallerySegue", sender: sender)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gallerySegue" {
            let controller = segue.destination as! GalleryViewController
            controller.newsItem = newsItem
            controller.galleryName = (sender as! UIButton).titleLabel?.text == "Gallery" ? "Images" : "Videos"
        }
    }
}

