//
//  ViewController.swift
//  social
//
//  Created by harry on 2017. 5. 8..
//  Copyright © 2017년 harry. All rights reserved.
//

import UIKit

//페이스북 모듈을 사용하기 위한 import
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //키체인 값이 있으면
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self){(result,error) in
            
            if error != nil{
                
                //custom message를 쉽게 찾기 위한 prefix를 붙이자.
                print("harry: unable to auth with facebook -\(error)")
            }else if result?.isCancelled == true{
                print("harry: user cancelled facebook auth")
            }else{
                print("harry: success auth with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        
        }
    }

    func firebaseAuthenticate(_ credental: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credental, completion: {(user,error) in
            
            if error != nil{
                print("harry: i want to kill him - \(error)")
            }else{
                print("harry:successs")
                if let user = user{
                    
                    self.completeSingIn(id: user.uid)
                    
                }
                
                
            }
            
            
        })
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JESS: Email user authenticated with Firebase")
                    if let user = user{
                        self.completeSingIn(id: user.uid)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            print("JESS: Successfully authenticated with Firebase")
                            if let user = user{
                                self.completeSingIn(id: user.uid)
                            }
                            
                            
                        }
                    })
                }
            })
        }
    }
    
    func completeSingIn(id: String){
        
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("data saved in keychain")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

