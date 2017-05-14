 //
//  Post.swift
//  social
//
//  Created by harry on 2017. 5. 14..
//  Copyright © 2017년 harry. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey:String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String{
        return _caption
    }
    
    var likes: Int{
        return _likes
    }
    
    var imagesUrl: String{
        return _imageUrl
    }
    
    var postKey: String{
        return _postKey
    }
    
    
    //생성자는 인자값만 다름 되나봄
    init(caption: String, imageUrl: String, likes: Int){
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    //post Data형태
    
    //                        553sdfs3 =     {
    //                            caption = "coffe is good";
    //                            imageUrl = "https://static1.00w";
    //                            likes = 256;
    //                        };

    
    
    init(postKey:String, postData: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageurl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
                self._likes = likes
        }
        
        _postRef = Dataservice.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool){
        if addLike{
            _likes = _likes + 1
        }else{
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }
}
