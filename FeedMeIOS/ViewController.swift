//
//  ViewController.swift
//  FeedMeIOS
//
//  Created by Jun Chen on 3/03/2016.
//  Copyright © 2016 FeedMe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    var restaurants = [String]()
    var logos = ["rest1", "rest2", "rest3", "rest4", "rest5", "rest6", "rest7"]
    
    var tableView = UITableView()
    //标记图片是否已经被选中
    var isFlag = [Bool](count : 12, repeatedValue: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let logo = UIImage(named: "LogoWhite.png")
//        self.navigationItem.titleView = UIImageView(image: logo)
        
        let ngColor = UIColor(red: 203/255, green:41/225, blue: 10/255, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = bgColor
        UINavigationBar.appearance().barTintColor = ngColor
        UITabBar.appearance().barTintColor = ngColor
        
        
        // Retrieve the list of all online shops' IDs:
        var shopIDs = [String]()
        shopIDs.append("1")
        shopIDs.append("17")
        shopIDs.append("18")
        shopIDs.append("19")
        shopIDs.append("20")
        shopIDs.append("21")
        shopIDs.append("22")
        
        for shopID in shopIDs {
            getShopData("http://ec2-52-27-149-51.us-west-2.compute.amazonaws.com:8080/restaurants/query/?id=" + shopID)
        }
        
        //之前这个地方定义的是var tableView局部变量，导致点了delete没反应
        tableView = UITableView(frame: CGRectMake(20, 50, 320, 600), style: UITableViewStyle.Plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let initIdentifier = "Cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: initIdentifier)
        //下面两个属性对应subtitle
        cell.textLabel?.text = restaurants[indexPath.row]
//        cell.detailTextLabel?.text = "baby\(indexPath.row)"
        
        //添加照片
        cell.imageView?.image = UIImage(named: logos[indexPath.row])
        cell.imageView!.layer.cornerRadius = 40
        cell.imageView!.layer.masksToBounds = true
        
        //添加附件
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        if isFlag[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    //每个cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //隐藏bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK
    func retrieveOnlineShops() {
        // retrieve data from databases:
        
    }
    
    func getShopData(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(myData!)
            })
        }
        
        task.resume()
    }
    
    func setLabels(weatherData: NSData) {
        let json: NSDictionary
        do {
            json = try NSJSONSerialization.JSONObjectWithData(weatherData, options: .AllowFragments) as! NSDictionary
            if let name = json["name"] as? String {
                restaurants.append(name)
                do_table_refresh()
            }
        } catch _ {
            
        }
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
}