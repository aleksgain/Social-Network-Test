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

    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addImage: CircleView!
    
    @IBOutlet weak var postCaption: UITextField!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot) in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap)
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }            
        }
        if let email = Auth.auth().currentUser?.email {
         userEmail.text = email
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("No image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
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
            "likes": 0 as AnyObject]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    

}
