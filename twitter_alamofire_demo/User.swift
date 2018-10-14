
import Foundation

class User {
    var name: String?
    var screenName: String?
    var location: String?
    var url: String?
    var description: String?
    var followersCount: Int?
    var friendsCount: Int?
    var favoritesCount: Int?
    var statusesCount: Int?
    var createdAt: String?
    var profileBackgroundImageUrl: String?
    var profileImageUrl: URL?
    var backgroundImageUrl: URL?
    
    // For user persistance
    var dictionary: [String: Any]?

    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    
    private static var _current: User?
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        location = dictionary["location"] as? String
        url = dictionary["url"] as? String
        description = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        favoritesCount = dictionary["favorites_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        createdAt = dictionary["created_at"] as? String
        profileBackgroundImageUrl = dictionary["profile_background_image_url"] as? String
        let profileImgString = dictionary["profile_image_url_https"] as? String
        profileImageUrl = URL(string: profileImgString!)
        

    }
}
