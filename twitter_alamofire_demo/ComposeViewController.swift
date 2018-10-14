//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Shrijan Aryal on 10/13/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit


protocol ComposeViewControllerDelegate:class {
    func did(post: Tweet)
}


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: ComposeViewControllerDelegate!
    var user:User = User.current!
    var startText = ""

    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var wordCountLabel: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        profileNameLabel.text = "@\(user.screenName!)"
        userNameLabel.text = user.name!
        
        let profilePhotoUrl = user.profileImageUrl
        profileImageView.af_setImage(withURL: profilePhotoUrl!)
        profileImageView.layer.cornerRadius = 25
        
        tweetTextView.text = startText
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //max character limit
        let textLimit = 140
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        wordCountLabel.title = "\(newText.characters.count)"
        
        // The new text should be allowed? True/False
        return newText.characters.count < textLimit
        
    }
    
   
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        if (tweetTextView.text != nil) {
            //print("Post tweet")
            APIManager.shared.composeTweet(with: tweetTextView.text) { (tweet, error) in
                if let error = error {
                    print("Error composing Tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    self.delegate?.did(post: tweet)
                    print("Compose Tweet Success!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }

}
