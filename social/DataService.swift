//
//  DataService.swift
//  social
//
//  Created by harry on 2017. 5. 13..
//  Copyright © 2017년 harry. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper
//database refrence를 지정해준다.
let DB_BASE = FIRDatabase.database().reference()
//storege레퍼런스를 가져오자
let STOREGE_BASE = FIRStorage.storage().reference()
class Dataservice{
    
    static let ds = Dataservice()
    
    private var _REF_BASE = DB_BASE
    //레퍼런스 하려하는데 데이터베이스 바로 아래에 있는 posts를 가져옴
    //각각 데이터를 가져옵니다.
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    //storege reference 
    private var _REF_POST_IMAGES = STOREGE_BASE.child("post-picks")
    
    var REEF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }

    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_POST_IMAGES : FIRStorageReference{
        return _REF_POST_IMAGES
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        //uid란 파이어베이스에서 objId 값 같은 느낌
        //없으면 만들어냄 값은 딕셔너리로 받음
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
