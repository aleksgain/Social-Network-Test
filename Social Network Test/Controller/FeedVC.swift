//
//  FeedVCViewController.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/23/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addImage: CircleView!
    
    @IBOutlet weak var postCaption: UITextField!
    
    @IBOutlet weak var userPic: UIImageView!
    
    var posts = [Post]()
    var user: UserInf! = nil
    var imagePicker: UIImagePickerController!
    var userpicPicker: UIImagePickerController!
    var imageSelected = false
    var image: UIImage!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        let usertap = UITapGestureRecognizer(target: self, action: #selector(userNameTapped))
        usertap.numberOfTapsRequired = 1
        userName.addGestureRecognizer(usertap)
        userName.isUserInteractionEnabled = true
        let pictap = UITapGestureRecognizer(target: self, action: #selector(userPicTapped))
        pictap.numberOfTapsRequired = 1
        userPic.addGestureRecognizer(pictap)
        userPic.isUserInteractionEnabled = true
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        DataService.ds.REF_USER_CURRENT.observe(.value) { (snapshot) in
            self.user = nil
            if let userData = snapshot.valueInExportFormat() as? Dictionary<String,AnyObject> {
            let userInf = UserInf(userData: userData)
            self.user = userInf
            }
            self.setUpUser(user: self.user)
        }
        
        
     }
    
    func setUpUser(user: UserInf) {
        userName.text = user.name
        if let url = NSURL(string: user.userpic) {
            if let data = NSData(contentsOf: url as URL) {
                userPic.image = UIImage(data: data as Data)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = nil
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.image = image
            imageSelected = true
        } else {
            print("No image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.addImage.image = self.image
        })
        })
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let error as NSError{
            print("Sign out failed", error)
        }
        performSegue(withIdentifier: "logOut", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? postCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                 cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post, img: nil)
            }
          return cell
        } else {
            return postCell()
        }

    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = postCaption.text, caption != "" else {
            print("Caption is missing")
            return
        }
        guard let image = addImage.image, imageSelected == true else {
            print("No image")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imageUID).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Error uploading image")
                } else {
                    print("Successfully uploaded picture to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.postToFirebase(imgUrl: downloadURL!)
                    self.postCaption.text = "Add a caption"
                    self.addImage.image = UIImage(named: "add-image")
                    self.imageSelected = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": postCaption.text as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject,
            "creatorId": Auth.auth().currentUser?.uid as AnyObject,
            "creatorName": user.name as AnyObject,
            "creatorPic": user.userpic as AnyObject]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
    }
    
    @objc func userNameTapped(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "", message: "Enter new name:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.userName.text
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0].text
            self.userName.text = textField
            DataService.ds.REF_USER_CURRENT.child("name").setValue(textField)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func userPicTapped(sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                self.userPic.image = self.image
            })
        })
        guard let image = userPic.image else {
            print("No image")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.0) {
            let userID = Auth.auth().currentUser?.uid
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_USERS_UPICS.child(userID!).putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Error uploading image")
                } else {
                    print("Successfully uploaded picture to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    let firebaseUser = DataService.ds.REF_USER_CURRENT.child("userpic")
                    firebaseUser.setValue(downloadURL)
                }
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    

}
