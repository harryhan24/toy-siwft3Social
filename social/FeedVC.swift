//
//  FeedVC.swift
//  social
//
//  Created by harry on 2017. 5. 8..
//  Copyright © 2017년 harry. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController ,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    
    
    var imageSelected = false
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        //데이터를 초기에 가져온다
        //data의 변동을 감지한다 value는 체인지 되는 값이다.
        Dataservice.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            //print(snapshot.value);
            
            // 데이터가 있다면 가져온다.
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                //snap shot loop
                for snap in snapshot{
                    print("snap:\(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            //그려주자
            self.tableView.reloadData()
        
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            //var img: UIImage!
            //캐시가 있으면 캐시값 같이 내려보냄
            if let img = FeedVC.imageCache.object(forKey: post.imagesUrl as NSString){
                cell.configureCell(post: post, img: img)
                return cell
            }else{
                cell.configureCell(post: post)
                return cell
            }
            
            
            
        }else{
            return PostCell()
        }
        
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            //선택한 이미지로 아이콘이 바뀜
            imageAdd.image = image
            imageSelected = true
        }else{
            print("h2: 이미지 선택안됬거나 적절치 않음")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else{
            print("h2: no caption")
            //finish with empty
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else{
            print("h2: no img")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            //식별가능한 유니크값을 만들어냄
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType="image/jpeg"
            
            Dataservice.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata:metadata){(metadata, error) in
            
                if error != nil{
                    print("succes!! for iamge!!!!")
                }else{
                    print("nono")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    //업로드가 성공적으로 된 경우에만 수행
                    if let url = downloadURL{
                            self.postToFirebase(imgUrl: downloadURL!)
                    }
                    
                }
            }
        }
    }
    
    
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, Any> = [
            "caption" : captionField.text!,
            "imageurl" : imgUrl,
            "likes": 0 //기본은 0
        ]
        
        //childByAutoId는 자동으로 아이디값을 만들어준다.
        let firebasePost = Dataservice.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        //업로드 후 초기화
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
        
    }
    
    @IBAction func signOutTrapped(_ sender: Any) {
        
        _ = KeychainWrapper.defaultKeychainWrapper.removeObject(forKey: KEY_UID)
        print("h2: logout!")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSingin", sender: nil)
    }
    
    
    


}
