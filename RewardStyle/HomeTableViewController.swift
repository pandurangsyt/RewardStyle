//
//  HomeTableViewController.swift
//  RewardStyle
//
//  Created by Pandu on 11/20/18.
//  Copyright © 2018 123 Apps Studio LLC. All rights reserved.
//

import UIKit
import Foundation

class HomeTableViewController: UITableViewController {

    var timeStampsArray = [String]()
    var styleImageURLArray = [String]()
    var avatarUrlArray = [String]()
    var displayNameArray = [String]()
    var profileIdArray = [String]()
    var styleImagesDictionary = [String: UIImage]()
    var avatarImagesDictionary = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // As there are 300 items and each page can have 20 so limiting the fetch pages to 15
        for page in 0..<15 {
            let rowOffset = 20 * page
            fetchAPIData(rowOffset)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timeStampsArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SampleTableViewCell
        cell.profileName.text = displayNameArray[indexPath.row]
        cell.timeStampLabel.text = timeStampsArray[indexPath.row]
        cell.profileImageView.image = avatarImagesDictionary[profileIdArray[indexPath.row]]
        cell.styelImageView.image = styleImagesDictionary[profileIdArray[indexPath.row]]
        return cell
    }
    
    

// Fetch API Data
    
    func fetchAPIData(_ rowOffset: Int) {
        let url = URL(string: "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=20&offset=\(rowOffset)")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                if let urlContent = data {
                    do {
                        let resultData = try JSONSerialization.jsonObject(with: urlContent, options: .mutableContainers) as! NSDictionary
                        let ltksDictionary = resultData.object(forKey: "ltks") as! [Dictionary<String, AnyObject>]
                        let profilesDictionary = resultData.object(forKey: "profiles") as! [Dictionary<String, AnyObject>]
                        
                        if ltksDictionary.count > 0 {
                            for ltksItem in ltksDictionary {
                                let timeStamp = ltksItem["date_published"] as! String
                                self.timeStampsArray.append(self.getTimeSince(timeStamp: timeStamp))
                                
                                let profileId = ltksItem["profile_id"] as! String
                                self.profileIdArray.append(profileId)
                                
                                let styleImage = ltksItem["hero_image"] as! String
                                self.styleImageURLArray.append(styleImage)
                                self.downloadImage(imageURL: styleImage, imageType: "Style", profileId: profileId)
                                
                                for profile in profilesDictionary {
                                    let id = profile["id"] as! String
                                    if id == profileId {
                                        let displayName = profile["display_name"] as! String
                                        self.displayNameArray.append(displayName)
                                        
                                        let avatarUrl = profile["avatar_url"] as! String
                                        self.avatarUrlArray.append(avatarUrl)
                                        self.downloadImage(imageURL: styleImage, imageType: "Avatar", profileId: profileId)
                                        break
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    catch{
                        // FUTURE - This can be handled with message to user about the error
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }
    
    func downloadImage(imageURL: String, imageType: String, profileId: String) {
        let url = URL(string: imageURL)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                let image = UIImage(data: data!)
                if imageType == "Avatar" {
                    self.avatarImagesDictionary[profileId] = image
                } else {
                    self.styleImagesDictionary[profileId] = image
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func getTimeSince(timeStamp: String) -> String {
        let dateFormatter = DateFormatter()
        let publishedTime = dateFormatter.date(from: timeStamp)
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let earliest: Date = publishedTime ?? Date()
        let latest: Date = Date()
        
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if components.year! >= 2 {
            let dateAgo = components.year ?? 0
            return "\(dateAgo) Years Ago"
        } else if components.year! >= 1 {
            if components.year! > 1 {
               return "1 Year Ago"
            } else {
               return "Last Year"
            }
        } else if components.month! >= 2 {
            let dateAgo = components.month ?? 0
            return "\(dateAgo) Months Ago"
        } else if components.month! >= 1 {
            if components.month! > 1 {
                return "1 Month Ago"
            } else {
                return "Last Month"
            }
        } else if components.weekOfYear! >= 2 {
            let dateAgo = components.weekOfYear ?? 0
            return "\(dateAgo) Weeks Ago"
        } else if components.weekOfYear! >= 1 {
            if components.weekOfYear! > 1 {
                return "1 Week Ago"
            } else {
                return "Last Week"
            }
        } else if components.day! >= 2 {
            let dateAgo = components.day ?? 0
            return "\(dateAgo) Days Ago"
        } else if components.day! >= 1 {
            if components.day! > 1 {
                return "1 Day Ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            let dateAgo = components.hour ?? 0
            return "\(dateAgo) Hours Ago"
        } else if components.hour! >= 1 {
            if components.hour! > 1 {
                return "1 Hour Ago"
            } else {
                return "An Hour Ago"
            }
        } else if components.minute! >= 2 {
            let dateAgo = components.minute ?? 0
            return "\(dateAgo) Minutes Ago"
        } else if components.minute! >= 1 {
            if components.minute! > 1 {
                return "1 Minute Ago"
            } else {
                return "An Minute Ago"
            }
        } else if components.second! >= 3 {
            let dateAgo = components.second ?? 0
            return "\(dateAgo) Seconds Ago"
        } else {
            return "Now"
        }
    }

}
