//
//  SinglePostViewController.swift
//  Latest Posts
//
//  Created by wlc on 9/16/15.
//  Copyright (c) 2015 wLc Designs. All rights reserved.
//

import UIKit

class SinglePostViewController: UIViewController, UIWebViewDelegate {

    lazy var json : JSON = JSON.null
    lazy var scrollView : UIScrollView = UIScrollView()
    lazy var postTitle : UILabel = UILabel()
    lazy var featuredImage : UIImageView = UIImageView()
    lazy var postTime : UILabel = UILabel()
    lazy var postContent : UILabel = UILabel()
    lazy var postContentWeb : UIWebView = UIWebView()
    lazy var generalPadding : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CGRect has 4 parameters: x,y,width,height
        scrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height)
        
        //We don't need horizontal scrolling
        scrollView.showsHorizontalScrollIndicator = false
        
        //Add the scrollView to the Single Post View Controller
        self.view.addSubview(scrollView)
        
        if let title = json["title"]["rendered"].string{
            
            /*
             * postTitle UI Label position:
             * x = 10px, y = 20px, width = screen width - 20px, height = 1px?!
             */
            
            postTitle.frame = CGRectMake(10, generalPadding, self.view.frame.size.width - 20, 1)
            
            //Title color is black...
            postTitle.textColor = UIColor.blackColor()
            
            //Title alignment is center...
            postTitle.textAlignment = NSTextAlignment.Center
            
            //Break long titles by word wrap
            postTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //Font size 24px...
            postTitle.font = UIFont.systemFontOfSize(24.0)
            
            //Number of line 0. Must be set to 0 to accomodate varying title lengths
            postTitle.numberOfLines = 0
            
            //Title text is the json title...
            postTitle.text = title
            
            //This is resizes the height of the title label to accomodate title text. That's why the CGRect height was set to 1px.
            postTitle.sizeToFit()
            
            //Add the postTitle UILabel to the scrollView
            self.scrollView.addSubview(postTitle)
        }
        
        if let featured = json["featured_image_thumbnail_url"].string{
            
            /*
            * featuredImage position:
            * x = 10px 
            * y = (height of postTitle + 20px)
            * width = screen width - 20px, 
            * height = 1/3 of screen height. Arbitrary.
            */
            
            featuredImage.frame = CGRect(x: 10, y: postTitle.frame.height + generalPadding, width: self.view.frame.size.width - 20, height: self.view.frame.size.height / 3)
            
            //Fill UIImageView to scale
            featuredImage.contentMode = .ScaleAspectFill
            
            //Equivelant to "overflow: hidden;"
            featuredImage.clipsToBounds = true
            
            //Load image outside main thread
            ImageLoader.sharedLoader.imageForUrl(featured, completionHandler:{(image: UIImage?, url: String) in
                self.featuredImage.image = image!
            })
            
            self.scrollView.addSubview(featuredImage)
        }
        
        if let date = json["date"].string{
            
            postTime.frame = CGRectMake(10, (generalPadding + 10 + postTitle.frame.height + featuredImage.frame.height), self.view.frame.size.width - 20, 10)
            postTime.textColor = UIColor.grayColor()
            postTime.font = UIFont(name: postTime.font.fontName, size: 12)
            postTime.textAlignment = NSTextAlignment.Left
            postTime.text = date
            
            self.scrollView.addSubview(postTime)
        }
        
        if let content = json["content"]["rendered"].string{
            
            /*
            postContent.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, 1)
            postContent.font = UIFont.systemFontOfSize(16.0)
            postContent.numberOfLines = 0
            postContent.text = content
            postContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
            postContent.sizeToFit()
            self.scrollView.addSubview(postContent)
            */
            
            let webContent : String = "<!DOCTYPE HTML><html><head><title></title><link rel='stylesheet' href='appStyles.css'></head><body>" + content + "</body></html>"
            let mainbundle = NSBundle.mainBundle().bundlePath
            let bundleURL = NSURL(fileURLWithPath: mainbundle)
            postContentWeb.loadHTMLString(webContent, baseURL: bundleURL)
            postContentWeb.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, 1)
            postContentWeb.delegate = self
            self.scrollView.addSubview(postContentWeb)
            
        }
        
        //print(json)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
    
        postContentWeb.frame = CGRectMake(10, (generalPadding * 2 + postTitle.frame.height + featuredImage.frame.height + postTime.frame.height), self.view.frame.size.width - 20, postContentWeb.scrollView.contentSize.height)
        
        var finalHeight : CGFloat = 0
        self.scrollView.subviews.forEach { (subview) -> () in
            finalHeight += subview.frame.height
        }
        
        self.scrollView.contentSize.height = finalHeight
    }

    /*
    // MARK: This method fires after all subviews have loaded
    override func viewDidLayoutSubviews() {
        
        //Set variable for final height. Cast it as CGFloat
        var finalHeight : CGFloat = 0
        
        //Loop through all subviews
        self.scrollView.subviews.forEach { (subview) -> () in
            
            //Add each subview height to finalHeight
            finalHeight += subview.frame.height
        }
        
        //Apply final height to scrollview
        self.scrollView.contentSize.height = finalHeight
        
        //NOTE: you maye need to add some padding

    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
