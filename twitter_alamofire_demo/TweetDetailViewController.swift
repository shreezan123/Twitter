//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Pranaya Adhikari on 3/23/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet!
    
    
    @IBOutlet weak var favoriteButtonLabel: UIButton!
    @IBOutlet weak var retweetButtonLabel: UIButton!
    @IBOutlet weak var replyButtonLabel: UIButton!
    @IBOutlet weak var favoritesLabelView: UILabel!
    @IBOutlet weak var retweetsLabelView: UILabel!
    @IBOutlet weak var tweetDateLabelView: UILabel!
    @IBOutlet weak var tweetLabelView: UILabel!
    @IBOutlet weak var profileNameLabelView: UILabel!
    @IBOutlet weak var usernameLabelView: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabelView.text = tweet.user.name
        profileNameLabelView.text = "@\(tweet.user.screenName!)"
        tweetLabelView.text = tweet.text
        tweetDateLabelView.text = tweet.createdAtString
        favoritesLabelView.text = "\(tweet.favoriteCount ?? 0)"
        retweetsLabelView.text = "\(tweet.retweetCount)"
        profileImageView.af_setImage(withURL: tweet.user.profileImageUrl!)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func onTapReply(_ sender: Any) {
    }
    
    
    
    @IBAction func onTapRetweet(_ sender: Any) {
        
        if (retweetButtonLabel.isSelected == true) {
            retweetButtonLabel.isSelected = false
            retweetButtonLabel.setImage(UIImage(named: "retweet-icon"), for: .normal)
            unRetweetTweet()
        }else {
            retweetButtonLabel.isSelected = true
            retweetButtonLabel.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            retweetTweet()
        }
        
        
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        if (favoriteButtonLabel.isSelected == true) {
            favoriteButtonLabel.isSelected = false
            favoriteButtonLabel.setImage(UIImage(named: "favor-icon"), for: .normal)
            unFavoriteTweet()
        }else {
            favoriteButtonLabel.isSelected = true
            favoriteButtonLabel.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            favoriteTweet()
        }
    }
    
    
    func favoriteTweet() {
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favoritied the following Tweet: \n\(tweet.text)")
                self.tweet.favoriteCount = self.tweet.favoriteCount! + 1
                self.tweet.favorited = true
                self.refreshData()
            }
        }
    }
    
    
    func unFavoriteTweet() {
        APIManager.shared.unFavorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error un-favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully un-favorited the following Tweet: \n\(tweet.text)")
                self.tweet.favoriteCount = self.tweet.favoriteCount! - 1
                self.tweet.favorited = false
                self.refreshData()
            }
        }
    }
    
    func retweetTweet() {
        APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error retweeting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                self.tweet.retweetCount += 1
                self.tweet.retweeted = true
                self.refreshData()
            }
        }
    }
    
    func unRetweetTweet() {
        APIManager.shared.unRetweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error un-retweeting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully un-retweeted the following Tweet: \n\(tweet.text)")
                self.tweet.retweetCount -= 1
                self.tweet.retweeted = false
                self.refreshData()
            }
        }
    }
    
    
    func refreshData() {
        retweetsLabelView.text = "\(tweet.retweetCount)"
        favoritesLabelView.text =  "\(tweet.favoriteCount ?? 0)"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "replySegue" {
            let replyVC = segue.destination as! ComposeViewController
            replyVC.startText = "@\(tweet.user.screenName!) "
            replyVC.postButton.title = "Reply"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
