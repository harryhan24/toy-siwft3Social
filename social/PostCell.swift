//
//  PostCell.swift
//  social
//
//  Created by harry on 2017. 5. 11..
//  Copyright © 2017년 harry. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    //let은 반드시 이니셜라이징 해야ㅕ함
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTDapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true

        
    }

    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        likesRef = Dataservice.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        
        
        if img != nil{
            //캐시가 있는경우 (이미지를 받는 경우)
            self.postImg.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imagesUrl)
            ref.data(withMaxSize: 2*1024*1024, completion: {(data,error) in
                
                if let imgData = data{
                    if let img = UIImage(data: imgData){
                        self.postImg.image = img
                        //이미지 캐시로 url과 이미지 저장
                        FeedVC.imageCache.setObject(img, forKey: post.imagesUrl as NSString)
                    }
                }
            })
        }
        

    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            //NSNull형태는 null이 아니다.
            if let _ = snapshot.value as? NSNull{
                //받는 값이 null이면
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }else{
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
        })
    }

}
