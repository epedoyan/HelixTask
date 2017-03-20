//
//  WebViewController.swift
//  HelixTask
//
//  Created by Codefights on 3/20/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

private let playerInsets: CGFloat = 8

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webview: UIWebView!
    
    var youtubeID: String?
    var htmlString: String?
    var playerSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         playerSize = webview.frame.size
        
        if self.youtubeID != nil {
            webview.loadHTMLString(iFrameHTMLStringWithSize(webview.frame.size), baseURL: URL(string: "http://www.youtube.com"))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.youtubeID != nil && playerSize != webview.frame.size {
            playerSize = webview.frame.size
            webview.loadHTMLString(iFrameHTMLStringWithSize(webview.frame.size), baseURL: URL(string: "http://www.youtube.com"))
        }
    }
    
    private func iFrameHTMLStringWithSize(_ size: CGSize) -> String {
        return "<iframe width=\"\(size.width - 2*playerInsets)\" height=\"\(size.height)\" src=\"https:www.youtube.com/embed/\(youtubeID!)\" frameborder=\"0\" allowfullscreen></iframe>"
    }

}
