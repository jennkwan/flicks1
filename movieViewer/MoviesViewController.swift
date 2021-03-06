//
//  MoviesViewController.swift
//  movieViewer
//
//  Created by Jennifer Kwan on 1/18/16.
//  Copyright © 2016 Jennifer Kwan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        

        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest()
        
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
//        let request = NSURLRequest(URL: url!)
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate:nil,
//            delegateQueue:NSOperationQueue.mainQueue()
//        )
//        
//        
//            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        
//        
//        
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
//            completionHandler: { (dataOrNil, response, error) in
//                
//                
//                
//                if let data = dataOrNil {
//                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
//                        data, options:[]) as? NSDictionary {
//                            print("response: \(responseDictionary)")
//                
//                            MBProgressHUD.hideHUDForView(self.view, animated: true)
//                            
//                            self.movies = responseDictionary["results"] as? [NSDictionary]
//                            self.tableView.reloadData()
//                    }
//                }
//        });
//        task.resume()
        
        
        
    }
    
    

    func refreshControlAction() {
        
        networkRequest()
        
//        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
//        let request = NSURLRequest(URL: url!)
//        
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate:nil,
//            delegateQueue:NSOperationQueue.mainQueue()
//        )
//        
//        
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        
//        
//        
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
//            completionHandler: { (dataOrNil, response, error) in
//            
//            
//            
//            if let data = dataOrNil {
//                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
//                data, options:[]) as? NSDictionary {
//                    print("response: \(responseDictionary)")
//                    
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
//                    
//                    self.movies = responseDictionary["results"] as? [NSDictionary]
//                    self.tableView.reloadData()
//                    self.refreshControl.endRefreshing()
//                }
//            }
//            });
//        task.resume()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
            
        } else {
            return 0
            
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.greenColor()
        cell.selectedBackgroundView = backgroundView
        
        cell.overviewLabel.text = overview
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: baseUrl + posterPath)
            cell.posterImage.setImageWithURL(posterURL!)
        }
        
        return cell
       
            
        }
        
        func networkRequest() {
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
            let request = NSURLRequest(URL: url!)
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                    
            
            
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                        
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                                
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        }
                
                    }else  {
                        print("There was a network error")
                    }
                    
            });
            task.resume()
            
        }
        
        func didRefresh() {
            
            networkRequest()
        }
//
//
//        
//        //let imageUrl = NSURL(string: baseUrl + posterPath)
//        
//        
//       // cell.posterImage.setImageWithURL(imageUrl!)
//        
//        
//        
//        //print("row \(indexPath.row)")
//        return cell
    

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
        
        print("prepare for segue called")
        
    }
}
