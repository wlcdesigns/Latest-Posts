//
//  LatestPostsTableViewController.swift
//  Latest Posts
//
//  Created by wlc on 7/15/15.
//  Copyright (c) 2015 wLc Designs. All rights reserved.
//

import UIKit
import Alamofire

class LatestPostsTableViewController: UITableViewController {

    let latestPosts : String = "https://wlcdesigns.com/wp-json/wp/v2/posts/"
    
    let parameters : [String:AnyObject] = [
        "filter[category_name]" : "tutorials",
        "filter[posts_per_page]" : 5
    ]
    
    var json : JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPosts(latestPosts)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("newNews"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func newNews()
    {
        getPosts(latestPosts)
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func getPosts(getposts : String)
    {
        Alamofire.request(.GET, getposts, parameters:parameters)
            .responseJSON { response in
                
                guard let data = response.result.value else{
                    print("Request failed with error")
                    return
                }
                
                self.json = JSON(data)
                self.tableView.reloadData()
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.json.type
        {
            case Type.Array:
                return self.json.count
            default:
                return 1
        }
    }
    
    func populateFields(cell: LatestPostsTableViewCell, index: Int){
        
        //Make sure post title is a string
        guard let title = self.json[index]["title"]["rendered"].string else{
            cell.postTitle!.text = "Loading..."
            return
        }
        
        // An action must always proceed the guard conditional
        cell.postTitle!.text = title
        
        //Make sure post date is a string
        guard let date = self.json[index]["date"].string else{
            cell.postDate!.text = "--"
            return
        }
        
        cell.postDate!.text = date
        
        /*
         * Set up Featured Image
         * Using guard, there's no need for nested if statements 
         * to unwrap and check optionals
         */
        
        guard let image = self.json[index]["featured_image_thumbnail_url"].string where
        image != "null"
            else{
            
            print("Image didn't load")
            return
        }
    
        ImageLoader.sharedLoader.imageForUrl(image, completionHandler:{(image: UIImage?, url: String) in
            cell.postImage.image = image!
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LatestPostsTableViewCell

        populateFields(cell, index: indexPath.row)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let singlePostVC : SinglePostViewController = storyboard!.instantiateViewControllerWithIdentifier("SinglePostViewController") as! SinglePostViewController
        singlePostVC.json = self.json[indexPath.row]
        self.navigationController?.pushViewController(singlePostVC, animated: true)
        
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Which view controller are we sending this to?
        var postScene = segue.destinationViewController as! WebViewController;
        
        //pass the selected JSON to the "viewPost variable of the WebViewController Class
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            let selected = self.json[indexPath.row]
            postScene.viewPost = selected
        }
        
    }
*/
    

}