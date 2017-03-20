//
//  GalleryViewController.swift
//  HelixTask
//
//  Created by Codefights on 3/19/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var newsItem: NewsItem?
    var galleryName: String?
    var youtubeID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    // MARK : Collection View DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let newsItem = newsItem {
            return galleryName == "Images" ? (newsItem.galleryThumbnailsURLs?.count)! : (newsItem.videosThumbnailsURLs?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        
        let thumbnailURL = galleryName == "Images" ? newsItem?.galleryThumbnailsURLs?[indexPath.row] : newsItem?.videosThumbnailsURLs?[indexPath.row]["thumbnailUrl"]
        
        youtubeID = galleryName == "Videos" ? newsItem?.videosThumbnailsURLs?[indexPath.row]["youtubeId"] : nil
        
        NetworkManager.shared.downloadImageAtURL(thumbnailURL!) { (image) in
            imageCell.thumbnailImageView.image = image
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)) )
        imageCell.addGestureRecognizer(tapGesture)
        return imageCell
    }

    func imageTapped(_ sender: UITapGestureRecognizer) {
        if galleryName == "Images" {
            let cell = sender.view as! ImageCell
            let imageView = cell.thumbnailImageView
            let newImageView = UIImageView(image: imageView?.image)
            newImageView.frame = self.view.frame
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        } else {
            performSegue(withIdentifier: "webViewSegue", sender: self)
        }
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            let controller = segue.destination as! WebViewController
            controller.youtubeID = youtubeID
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
