//
//  LoginViewController.swift
//  BubblUp
//
//  Created by WUSTL STS on 3/8/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController/*, FBSDKLoginButtonDelegate*/ {

    @IBOutlet weak var passwordReTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    //@IBOutlet weak var loginView: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.returnButton.enabled = false
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
           // loginView.readPermissions = ["public_profile", "email", "user_friends"]
          //  loginView.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        print("on login button")
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            
            if let user = user {
                print("logged in!")
                self.performSegueWithIdentifier("goToMainView", sender: nil)
            }
        }
        
    }

    @IBAction func onSignupButton(sender: AnyObject) {
        
        if passwordReTextField.alpha == 0 {
            
            self.loginButton.enabled = false
            self.returnButton.enabled = true
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: {
                self.passwordReTextField.alpha = 1.0
                self.returnButton.center.y += 30
                self.loginButton.center.y += 30
                self.loginButton.alpha = 0.0
                self.returnButton.alpha = 1.0

                
            }) { (success: Bool) in
            }
        }
        
        else {
            let newUser = PFUser()
            newUser.username = usernameTextField.text
            newUser.password = passwordTextField.text
            
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                
                if success {
                    print("made user")
                    self.performSegueWithIdentifier("goToMainView", sender: nil)
                    
                } else {
                    print(error?.localizedDescription)
                    if error!.code == 202 {
                        print("username already taken")
                    }
                }
                
            }
        }

    }
    
    @IBAction func onSecondButton(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    self.performSegueWithIdentifier("goToMainView", sender: nil)
                } else {
                    print("User logged in through Facebook!")
                     self.performSegueWithIdentifier("goToMainView", sender: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }

    }

    @IBAction func onReturnButton(sender: AnyObject) {
        
        self.loginButton.enabled = true
        self.returnButton.enabled = false
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: {
            self.passwordReTextField.alpha = 0.0
            self.returnButton.center.y -= 30
            self.loginButton.center.y -= 30
            self.loginButton.alpha = 1.0
            self.returnButton.alpha = 0.0
            
            
        }) { (success: Bool) in
        }

    }
    
    
    //    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("User Logged In")
//        
//        if ((error) != nil)
//        {
//            print(error.localizedDescription)
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("email")
//            {
//                            }
//        }
//    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                self.usernameTextField.text = result.valueForKey("email") as! String

            }
        })
    }

}
