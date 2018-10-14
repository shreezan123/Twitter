
import UIKit
import Alamofire
import AlamofireImage


class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetButtonLabel: UIButton!
    
    @IBOutlet weak var favoriteButtonLabel: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var replyCountLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            dateLabel.text = tweet.createdAtString
            profileNameLabel.text = tweet.user.screenName
            nameLabel.text = tweet.user.name
            //replyCountLabel.text = tweet.reply
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoritesCountLabel.text =  "\(tweet.favoriteCount ?? 0)"
            profileImageView.af_setImage(withURL: tweet.user.profileImageUrl!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onFavorites(_ sender: Any) {
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
    
    @IBAction func onReply(_ sender: Any) {
        
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
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
    

    
    @IBAction func onMessage(_ sender: Any) {
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
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoritesCountLabel.text =  "\(tweet.favoriteCount ?? 0)"
    }
}
