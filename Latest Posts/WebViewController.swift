//
//  WebViewController.swift
//  Latest Posts
//
//  Created by wlc on 8/27/15.
//  Copyright (c) 2015 wLc Designs. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var viewPost : JSON = JSON.nullJSON
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make sure the json is returning the post url as a string
        if let postLink = self.viewPost["link"].string{
            
            //Convert the url string to a NSURL object
            let requestURL = NSURL(string: postLink)
            
            //Create a request from NSURL
            let request = NSURLRequest(URL: requestURL!)
            
            webView.delegate = self
            
            //Load the post
            webView.loadRequest(request)
            
            //Set the title of the navigation bar to the title of the WordPress Post
            if let title = self.viewPost["title"].string{
                self.title = title
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
