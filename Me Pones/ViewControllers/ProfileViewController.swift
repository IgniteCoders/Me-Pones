//
//  ProfileViewController.swift
//  Me Pones
//
//  Created by Mañanas on 19/9/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UITableViewController,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
    
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        fetchUser()
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        let db = Firestore.firestore()
        
        let userID = Auth.auth().currentUser!.uid
        
        //let user = User(id: userID, username: Auth.auth().currentUser!.email!, biography: biographyTextView.text)
        
        user?.biography = biographyTextView.text
        
        do {
            try db.collection("Users").document(userID).setData(from: user)
            self.showToast(message: "Perfil actualizado correctamente")
        } catch let error {
            print("Error writing user to Firestore: \(error)")
        }
    }
    
    func fetchUser() {
        let db = Firestore.firestore()
        
        let userID = Auth.auth().currentUser!.uid
        
        let docRef = db.collection("Users").document(userID)
        
        Task {
            do {
                user = try await docRef.getDocument(as: User.self)
                guard let user = user else {
                    return
                }
                biographyTextView.text = user.biography
                
                if user.profileImageUrl != nil && !user.profileImageUrl!.isEmpty {
                    profileImageView.loadFrom(url: user.profileImageUrl!)
                } else {
                    profileImageView.image = UIImage(systemName: "person.circle.fill")
                }
            } catch {
                print("Error decoding user: \(error)")
            }
        }
    }
    
    // MARK: ImagePicker Delegate
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let data = image.jpegData(compressionQuality: 0.8)
            
            let userID = Auth.auth().currentUser!.uid
            
            // Create a reference to the file you want to upload
            let profileImageRef = storageRef.child("\(userID)/profileImage.jpg")
            
            // Upload the file to the path "userID/profileImage.jpg"
            let uploadTask = profileImageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                profileImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    self.user?.profileImageUrl = downloadURL.absoluteString
                }
            }
        }
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        default: break
        }
    }
    
    // MARK: - Table view data source
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }*/
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
